require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "can create a valid user" do
    user = GWD::User.new(id: "Sample ID", etag: "Sample etag", email: "Sample email", org_unit: "Sample/OU", suspended: false, email_aliases: [])

    assert user.valid?, "User with required fields is not valid"
  end

  test "ID is required" do
    user = gwd_users(:valid_user)
    user.id = nil
    assert_not user.valid?, "User is valid despite missing ID"
  end

  test "ID is required by database too" do
    user = gwd_users(:valid_user)
    user.id = nil
    assert_raises(ActiveRecord::StatementInvalid) {
      user.save(validate: false)
    }
  end

  test "etag is required" do
    user = gwd_users(:valid_user)
    user.etag = nil
    assert_not user.valid?, "User is valid despite missing etag"
  end

  test "etag is required by database too" do
    user = gwd_users(:valid_user)
    user.etag = nil
    assert_raises(ActiveRecord::StatementInvalid) {
      user.save(validate: false)
    }
  end

  test "email is required" do
    user = gwd_users(:valid_user)
    user.email = nil
    assert_not user.valid?, "User is valid despite missing email"
  end

  test "email is required by database too" do
    user = gwd_users(:valid_user)
    user.email = nil
    assert_raises(ActiveRecord::StatementInvalid) {
      user.save(validate: false)
    }
  end

  test "org_unit is required" do
    user = gwd_users(:valid_user)
    user.org_unit = nil
    assert_not user.valid?, "User is valid despite missing org_unit"
  end

  test "org_unit is required by database too" do
    user = gwd_users(:valid_user)
    user.org_unit = nil
    assert_raises(ActiveRecord::StatementInvalid) {
      user.save(validate: false)
    }
  end

  test "suspended is required" do
    user = gwd_users(:valid_user)
    user.suspended = nil
    assert_not user.valid?, "User is valid despite missing suspended"
  end

  test "suspended is required by database too" do
    user = gwd_users(:valid_user)
    user.suspended = nil
    assert_raises(ActiveRecord::StatementInvalid) {
      user.save(validate: false)
    }
  end

  test "email_aliases can't be nil (but can be default or empty)" do
    user = gwd_users(:valid_user)

    user.email_aliases = nil
    assert_not user.valid?, "User is valid despite nil email_aliases"

    user.email_aliases = []
    assert user.valid?, "User is not valid despite email_aliases not nil"

    new_user_aliases_not_specfied = GWD::User.new(id: "Sample ID", etag: "Sample etag", email: "Sample email", org_unit: "Sample/OU", suspended: false)
    assert new_user_aliases_not_specfied.valid?, "User is not valid despite default email_aliases"
  end

  test "email_aliases is required by database too" do
    user = gwd_users(:valid_user)

    user.email_aliases = nil
    assert_raises(ActiveRecord::StatementInvalid) {
      user.save!(validate: false)
    }

    user.email_aliases = []
    user.save! # `assert_nothing_raised` does nothing, use ! bang method

    new_user_aliases_not_specfied = GWD::User.new(id: "Sample ID", etag: "Sample etag", email: "Sample email", org_unit: "Sample/OU", suspended: false)
    new_user_aliases_not_specfied.save!(validate: false)
  end

  test "active scope only returns active users" do
    regular_user = gwd_users(:valid_user)
    suspended_user = GWD::User.create!(id: "Suspended user ID", etag: "Suspended user etag", email: "Suspended user email", org_unit: "Some/OU", suspended: true)
    deleted_user = GWD::User.create!(id: "Deleted user ID", etag: "Deleted user etag", email: "Deleted user email", org_unit: "Some/OU", suspended: false, deleted_at: Time.now - 1.minutes)

    assert_equal 3, GWD::User.count
    assert_equal 1, GWD::User.active.count
  end

  test "suspended scope only returns suspended users" do
    regular_user = gwd_users(:valid_user)
    suspended_user = GWD::User.create!(id: "Suspended user ID", etag: "Suspended user etag", email: "Suspended user email", org_unit: "Some/OU", suspended: true)
    deleted_user = GWD::User.create!(id: "Deleted user ID", etag: "Deleted user etag", email: "Deleted user email", org_unit: "Some/OU", suspended: false, deleted_at: Time.now - 1.minutes)

    assert_equal 3, GWD::User.count
    assert_equal 1, GWD::User.suspended.count
  end

  test "deleted scope only returns deleted users" do
    regular_user = gwd_users(:valid_user)
    suspended_user = GWD::User.create!(id: "Suspended user ID", etag: "Suspended user etag", email: "Suspended user email", org_unit: "Some/OU", suspended: true)
    deleted_user = GWD::User.create!(id: "Deleted user ID", etag: "Deleted user etag", email: "Deleted user email", org_unit: "Some/OU", suspended: false, deleted_at: Time.now - 1.minutes)

    assert_equal 3, GWD::User.count
    assert_equal 1, GWD::User.deleted.count
  end

  test "user record can optionally belong to person" do
    user = gwd_users(:valid_user)
    assert_nil user.person # optional

    user.update(person: people(:valid_person))

    assert_equal people(:valid_person).directory_users.first, user
  end
end
