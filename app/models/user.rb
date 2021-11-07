class User < ApplicationRecord
  include Clearance::User

  def confirm_email
    self.email_confirmed_at = Time.current
    self.email_confirmation_token = ""
    save
  end
end
