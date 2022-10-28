require "test_helper"

class GroupTest < ActiveSupport::TestCase
  test "can create a valid group" do
    group = GWD::Group.new(id: "Group ID", etag: "Group etag", email: "Group email", name: "Group name")

    assert group.valid?, "Group with required fields is not valid"
  end

  test "ID is required" do
    group = gwd_groups(:valid_group)
    group.id = nil
    assert_not group.valid?, "Group is valid despite missing ID"
  end

  test "ID is required by database too" do
    group = gwd_groups(:valid_group)
    group.id = nil
    assert_raises(ActiveRecord::StatementInvalid) {
      group.save(validate: false)
    }
  end

  test "etag is required" do
    group = gwd_groups(:valid_group)
    group.etag = nil
    assert_not group.valid?, "Group is valid despite missing etag"
  end

  test "etag is required by database too" do
    group = gwd_groups(:valid_group)
    group.etag = nil
    assert_raises(ActiveRecord::StatementInvalid) {
      group.save(validate: false)
    }
  end

  test "email is required" do
    group = gwd_groups(:valid_group)
    group.email = nil
    assert_not group.valid?, "Group is valid despite missing email"
  end

  test "email is required by database too" do
    group = gwd_groups(:valid_group)
    group.email = nil
    assert_raises(ActiveRecord::StatementInvalid) {
      group.save(validate: false)
    }
  end

  test "name is required" do
    group = gwd_groups(:valid_group)
    group.name = nil
    assert_not group.valid?, "Group is valid despite missing name"
  end

  test "name is required by database too" do
    group = gwd_groups(:valid_group)
    group.name = nil
    assert_raises(ActiveRecord::StatementInvalid) {
      group.save(validate: false)
    }
  end

  test "active scope only returns active groups" do
    regular_group = gwd_groups(:valid_group)
    deleted_group = GWD::Group.create!(id: "Group ID", etag: "Group etag", email: "Group email", name: "Group name", deleted_at: Time.now - 1.minutes)

    assert_equal 2, GWD::Group.count
    assert_equal 1, GWD::Group.active.count
  end

  test "deleted scope only returns deleted groups" do
    regular_group = gwd_groups(:valid_group)
    deleted_group = GWD::Group.create!(id: "Group ID", etag: "Group etag", email: "Group email", name: "Group name", deleted_at: Time.now - 1.minutes)

    assert_equal 2, GWD::Group.count
    assert_equal 1, GWD::Group.deleted.count
  end
end
