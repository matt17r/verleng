require "test_helper"

class StaticControllerTest < ActionDispatch::IntegrationTest
  test "static home page resolves" do
    get "/page/home"
    assert_response :success
  end

  test "missing template raises a routing error (which becomes a 404 later)" do
    get "/page/this-is-a-made-up-url"
    assert_raises(ActionController::RoutingError)
  end
end
