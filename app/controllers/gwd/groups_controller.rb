class GWD::GroupsController < ApplicationController
  before_action :require_login
  before_action :set_gwd_group, only: %i[ show destroy ]

  def index
    @gwd_groups = GWD::Group.active
  end

  def show
  end

  def destroy
    @gwd_group.update!(deleted_at: Time.now)
    redirect_to gwd_groups_url, notice: "Group was successfully deleted."
  end

  private

  def set_gwd_group
    @gwd_group = GWD::Group.find(params[:id])
  end

  def gwd_group_params
    params.require(:gwd_group).permit(:etag, :name, :email, :description, :aliases, :deleted_at)
  end
end
