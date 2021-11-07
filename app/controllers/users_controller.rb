class UsersController < Clearance::UsersController
  def create
    @user = user_from_params
    @user.email_confirmation_token = Clearance::Token.new

    if @user.save
      UserMailer.send_confirmation_email(user: @user).deliver_later
      redirect_to root_path, notice: t("flashes.confirmation_pending")
    else
      render template: "users/new"
    end
  end
end
