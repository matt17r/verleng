class UserMailer < ApplicationMailer
  def send_confirmation_email(user:)
    @user = user
    mail(
      from: email_address_with_name("confirmation@verleng.com", "Verleng"),
      to: @user.email,
      subject: I18n.t(
        :confirm_email,
        scope: [:clearance, :models, :clearance_mailer]
      )
    )
  end
end
