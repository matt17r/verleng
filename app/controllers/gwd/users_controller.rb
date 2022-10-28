class GWD::UsersController < ApplicationController
  before_action :require_login
  before_action :set_gwd_user, only: %i[ show destroy ]

  def index
    @gwd_users = GWD::User.active
  end

  def show
  end

  def destroy
    @gwd_user.update!(deleted_at: Time.now)
    redirect_to gwd_users_url, notice: "User was successfully deleted."
  end

  private

  def set_gwd_user
    @gwd_user = GWD::User.find(params[:id])
  end

  def gwd_user_params
    params.require(:gwd_user).permit(:person_id, :etag, :given_name, :family_name, :full_name, :email, :email_aliases, :org_unit, :suspended, :deleted_at, :image, :image_etag)
  end
end
