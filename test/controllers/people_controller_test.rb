require "test_helper"

class PeopleControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    user = users(:one)

    get people_url(as: user)

    assert_response :success
  end

  test "should show person" do
    person = people(:one_name)
    user = users(:one)

    get person_url(person, as: user)

    assert_response :success
  end

  test "should destroy person" do
    person = people(:one_name)
    user = users(:one)

    assert_difference("Person.count", -1) do
      delete person_url(person, as: user)
    end

    assert_redirected_to people_url
  end
end
