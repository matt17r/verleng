class EmailConfirmationsController < ApplicationController
  def update
    user = User.find_by(email_confirmation_token: params[:token])
    return redirect_to root_path, alert: t("flashes.confirmation_token_missing") unless user
    user.confirm_email
    sign_in user
    redirect_to root_path, notice: t("flashes.confirmed_email")
  end
end
