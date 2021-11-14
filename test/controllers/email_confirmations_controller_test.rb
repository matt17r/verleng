require "test_helper"

class EmailConfirmationsControllerTest < ActionDispatch::IntegrationTest
  test "should confirm user's email" do
    post users_url, params: {user: {email: "email_confirmation@example.com", password: "tobeconfirmed"}}
    new_user = User.find_by(email: "email_confirmation@example.com")
    assert_not_nil new_user.email_confirmation_token
    assert_nil new_user.email_confirmed_at

    get "/confirm_email/#{new_user.email_confirmation_token}"

    follow_redirect!
    assert_equal 200, status
    new_user.reload
    assert_not_nil new_user.email_confirmed_at
    assert_empty new_user.email_confirmation_token
  end
end
