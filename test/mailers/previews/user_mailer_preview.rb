# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def send_confirmation_email
    user = User.last.remove_email_confirmation

    UserMailer.send_confirmation_email(user: user)
  end
end
