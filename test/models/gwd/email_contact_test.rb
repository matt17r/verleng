require "test_helper"

class GWD::EmailContactTest < ActiveSupport::TestCase
  test "can create a valid contact" do
    contact = GWD::EmailContact.new(id: "Contact ID", email: "contact@example.com")

    assert contact.valid?, "Contact with required fields is not valid"
  end

  test "ID is required" do
    contact = gwd_email_contacts(:valid_contact)
    contact.id = nil
    assert_not contact.valid?, "Contact is valid despite missing ID"
  end

  test "ID is required by database too" do
    contact = gwd_email_contacts(:valid_contact)
    contact.id = nil
    assert_raises(ActiveRecord::StatementInvalid) {
      contact.save(validate: false)
    }
  end

  test "email is required" do
    contact = gwd_email_contacts(:valid_contact)
    contact.email = nil
    assert_not contact.valid?, "Contact is valid despite missing email"
  end

  test "email must be valid format" do
    contact = gwd_email_contacts(:valid_contact)

    contact.email = "Non email string"
    assert_not contact.valid?, "Contact is valid despite invalid email format"

    contact.email = "test@test@test.com"
    assert_not contact.valid?, "Contact is valid despite invalid email format"
  end

  test "email must not be internal" do
    contact = gwd_email_contacts(:valid_contact)

    internal_address = "test@#{Rails.application.credentials.internal_domains.first}"
    contact.email = internal_address
    assert_not contact.valid?, "External contact is valid despite internal email address"
  end

  test "email is required by database too" do
    contact = gwd_email_contacts(:valid_contact)
    contact.email = nil
    assert_raises(ActiveRecord::StatementInvalid) {
      contact.save(validate: false)
    }
  end

  test "active scope only returns active contacts" do
    regular_contact = gwd_email_contacts(:valid_contact)
    deleted_contact = GWD::EmailContact.create!(id: "Contact ID", email: "test@example.org", deleted_at: Time.now - 1.minutes)

    assert_equal 2, GWD::EmailContact.count
    assert_equal 1, GWD::EmailContact.active.count
  end

  test "deleted scope only returns deleted contacts" do
    regular_contact = gwd_email_contacts(:valid_contact)
    deleted_contact = GWD::EmailContact.create!(id: "Contact ID", email: "test@example.net", deleted_at: Time.now - 1.minutes)

    assert_equal 2, GWD::EmailContact.count
    assert_equal 1, GWD::EmailContact.deleted.count
  end

  test "email contact can optionally belong to person" do
    contact = gwd_email_contacts(:valid_contact)
    assert_nil contact.person # optional

    contact.update!(person: people(:valid_person))

    assert_equal people(:valid_person).directory_contacts.first, contact
  end
end
