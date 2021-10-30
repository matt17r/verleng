class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name("notifications@verleng.com", "Welcome to Verleng")
  layout "mailer"
end
