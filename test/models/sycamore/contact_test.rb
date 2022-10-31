require "test_helper"

class Sycamore::ContactTest < ActiveSupport::TestCase
  test "can create a valid contact" do
    contact = Sycamore::Contact.new(id: 12345)

    assert contact.valid?, "Contact with required fields is not valid"
  end

  test "active scope only returns active contacts" do
    regular_contact = sycamore_contacts(:valid_contact)
    deleted_contact = Sycamore::Contact.create!(id: 12345, deleted_at: Time.now - 1.minutes)

    assert_equal 2, Sycamore::Contact.count
    assert_equal 1, Sycamore::Contact.active.count
  end

  test "deleted scope only returns deleted contacts" do
    regular_contact = sycamore_contacts(:valid_contact)
    deleted_contact = Sycamore::Contact.create!(id: 12345, deleted_at: Time.now - 1.minutes)

    assert_equal 2, Sycamore::Contact.count
    assert_equal 1, Sycamore::Contact.deleted.count
  end

  test "contact record can optionally belong to person" do
    contact = sycamore_contacts(:valid_contact)
    assert_nil contact.person # optional

    contact.update(person: people(:valid_person))

    assert_equal people(:valid_person).sis_contacts.first, contact
  end
end
