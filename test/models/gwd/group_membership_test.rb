require "test_helper"

class GroupMembershipTest < ActiveSupport::TestCase
  test "can create a valid user group membership" do
    group = gwd_groups(:valid_group)
    user = gwd_users(:valid_user)
    group_membership = GWD::GroupMembership.new(group: group, member: user, email: user.email, role: "member")

    assert group_membership.valid?, "Group Membership with required fields is not valid"
  end

  test "can create a valid email contact group membership" do
    group = gwd_groups(:valid_group)
    contact = gwd_email_contacts(:valid_contact)
    group_membership = GWD::GroupMembership.new(group: group, member: contact, email: contact.email, role: "member")

    assert group_membership.valid?, "Group Membership with required fields is not valid"
  end

  test "can create a valid child group group membership" do
    parent_group = gwd_groups(:valid_group)
    child_group = group = GWD::Group.create!(id: "Child Group ID", etag: "Child Group etag", email: "Child Group email", name: "Child Group")
    group_membership = GWD::GroupMembership.new(group: parent_group, member: child_group, email: child_group.email, role: "member")

    assert group_membership.valid?, "Group Membership with required fields is not valid"
  end

  test "can add multiple members to a group, each with different types" do
    group = gwd_groups(:valid_group)
    user = gwd_users(:valid_user)
    contact = gwd_email_contacts(:valid_contact)
    child_group = group = GWD::Group.create!(id: "Child Group ID", etag: "Child Group etag", email: "Child Group email", name: "Child Group")

    GWD::GroupMembership.create!(group: group, member: user, email: user.email, role: "member")
    GWD::GroupMembership.create!(group: group, member: contact, email: contact.email, role: "member")
    GWD::GroupMembership.create!(group: group, member: child_group, email: child_group.email, role: "member")

    assert_equal 3, group.memberships.count
    assert_equal 1, group.member_users.count
    assert_equal 1, group.member_groups.count
    assert_equal 1, group.member_contacts.count
  end

  test "child group can access parent group" do
    parent_group = gwd_groups(:valid_group)
    child_group = group = GWD::Group.create!(id: "Child Group ID", etag: "Child Group etag", email: "Child Group email", name: "Child Group")
    group_membership = GWD::GroupMembership.create!(group: parent_group, member: child_group, email: child_group.email, role: "member")

    assert_includes child_group.groups, parent_group
  end
end
