require "test_helper"

class PeopleControllerTest < ActionDispatch::IntegrationTest
  setup do
    @person = people(:one_name)
  end

  test "should get index" do
    get people_url
    assert_response :success
  end

  test "should show person" do
    get person_url(@person)
    assert_response :success
  end

  test "should destroy person" do
    assert_difference("Person.count", -1) do
      delete person_url(@person)
    end

    assert_redirected_to people_url
  end
end
