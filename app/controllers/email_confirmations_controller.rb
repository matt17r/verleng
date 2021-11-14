class EmailConfirmationsController < ApplicationController
  def update
    sign_out if signed_in?
    user = User.find_by(email_confirmation_token: params[:token])
    return redirect_to root_path, alert: t("flashes.confirmation_token_missing") unless user
    user.confirm_email
    redirect_to sign_in_path, notice: t("flashes.email_confirmed")
  end
end
