require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should create user" do
    assert_difference("User.count") do
      post users_url, params: {user: {email: "create_user@example.com", password: "creativity"}}
    end

    new_user = User.find_by(email: "create_user@example.com")
    assert_not_nil new_user.email_confirmation_token
  end
end
