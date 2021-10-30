class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name(ENV["EMAIL_FROM_ADDRESS"], "Verleng")
  layout "mailer"
end
