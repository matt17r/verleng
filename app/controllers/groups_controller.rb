class GroupsController < ApplicationController
  before_action :set_group, only: %i[ show ]

  def index
    @groups = Group.includes(:members).all.order(:name)
  end

  def show
  end

  private
  
  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name, :dir_id, :dir_email, :dir_description, :dir_aliases)
  end
end
