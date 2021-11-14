class User < ApplicationRecord
  include Clearance::User

  def confirm_email
    update!(email_confirmation_token: "", email_confirmed_at: Time.now)
    self
  end

  def remove_email_confirmation
    update!(email_confirmation_token: Clearance::Token.new, email_confirmed_at: nil)
    self
  end
end
