class PeopleController < ApplicationController
  before_action :require_login
  before_action :set_person, only: %i[show destroy update_groups]

  def index
    @people = Person.sorted_by_name
  end

  def show
  end
  
  def update_groups
    num_groups_created = 0
    num_memberships_added = 0
    ugf = Google::UserGroupsFetcher.call(email: @person.school_email)
    unless ugf.success?
      Rails.logger.error("UserGroupsFetcher failed - #{ugf.errors}")
      return redirect_to @person, alert: "Fetching of groups failed"
    end
    
    if ugf.payload && ugf.payload.size > 0
      ugf.payload.each do |g|
        group = Group.find_or_initialize_by(dir_id: g[:id])
        if !group.persisted?
          group.update!(name: g[:name], dir_name: g[:name], dir_email: g[:email], dir_description: g[:description], dir_aliases: g[:aliases] || [])
          num_groups_created += 1
        end
        membership = DirectoryGroupMembership.find_or_initialize_by(group: group, person: @person)
        if !membership.persisted?
          membership.save!
          num_memberships_added += 1
        end
      end
    end
    
    redirect_to @person, notice: "#{t('.groups_created', count: num_groups_created) if num_groups_created > 0} #{t('.memberships_added', count: num_memberships_added)}"
  end

  def destroy
    @person.destroy
    respond_to do |format|
      format.html { redirect_to people_url, notice: "Person was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_person
    @person = Person.find(params[:id])
  end

  def person_params
    params
      .require(:person)
      .permit(:official_given_name, :official_family_name, :preferred_given_name, :preferred_family_name,
        :local_given_name, :local_family_name, :other_given_names, :display_name, :formal_name, :sort_name,
        :additional_name_details, :date_of_birth, :gender, :school_email, :personal_email, :school_phone,
        :personal_phone, :other_contact_details)
  end
end
