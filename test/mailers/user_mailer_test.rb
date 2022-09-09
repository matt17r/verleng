require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "invite" do
    email = UserMailer.send_confirmation_email(user: users(:controller_test_user))

    # Send the email, then test that it got queued
    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ["confirmation@verleng.com"], email.from
    assert_equal ["test@example.com"], email.to
    assert_equal I18n.t(:confirm_email, scope: [:clearance, :models, :clearance_mailer]), email.subject
  end
end
