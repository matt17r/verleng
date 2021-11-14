Clearance.configure do |config|
  config.mailer_sender = "verleng@verleng.com"
  config.rotate_csrf_on_sign_in = true
  config.routes = false
  config.signed_cookie = true
  config.sign_in_guards = ["EmailConfirmationGuard"]
end
