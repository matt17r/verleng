class GroupsController < ApplicationController
  before_action :set_group, only: %i[ show update_members ]

  def index
    @groups = Group.includes(:members).all.order(:name)
  end

  def show
  end
  
  def update_members
    num_people_skipped = 0
    num_members_added = 0
    gmf = Google::GroupMembersFetcher.call(group_email_or_id: @group.dir_email)
    unless gmf.success?
      Rails.logger.error("GroupMembersFetcher failed - #{gmf.errors}")
      return redirect_to @group, alert: "Fetching of group memberships failed"
    end
    
    if gmf.payload && gmf.payload.size > 0
      gmf.payload.each do |m|
        next unless m[:type] == "USER"
        person = Person.find_by(school_email: m[:email]) || Person.find_by(personal_email: m[:email])
        if !person
          Rails.logger.warn("Group member skipped, person not found - #{m[:email]}")
          num_people_skipped += 1
          next
        end
        membership = DirectoryGroupMembership.find_or_initialize_by(group: @group, person: person)
        if !membership.persisted?
          membership.save!
          num_members_added += 1
        end
      end
    end
    
    redirect_to @group, notice: "#{t('.people_skipped', count: num_people_skipped) if num_people_skipped > 0} #{t('.members_added', count: num_members_added)}"
  end

  private
  
  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name, :dir_id, :dir_email, :dir_description, :dir_aliases)
  end
end
