require "test_helper"

class PersonTest < ActiveSupport::TestCase
  test "a given name is required" do
    person = Person.new

    assert_not person.save, "Saved the person without a given name"
  end

  test "a given name is required by the database too" do
    assert_raises(ActiveRecord::StatementInvalid) {
      person = Person.new
      person.save(validate: false)
    }
  end

  test "given name can be official" do
    person = Person.new(official_given_name: "Madonna")

    assert person.save
  end

  test "given name can be preferred" do
    person = Person.new(preferred_given_name: "Ronaldinho")

    assert person.save
  end

  test "given name returns official name if no preferred name" do
    person = Person.new(official_given_name: "Madonna")

    assert_equal "Madonna", person.given_name
  end

  test "given name returns preferred name if specified" do
    person = Person.new(
      official_given_name: "Laura",
      other_given_names: "Jeanne Reese",
      official_family_name: "Witherspoon",
      preferred_given_name: "Reese"
    )

    assert_equal "Laura", person.official_given_name
    assert_equal "Reese", person.preferred_given_name
    assert_equal "Reese", person.given_name
  end

  test "family name returns nothing if no official or preferred name" do
    person = Person.new(official_given_name: "Prince")

    assert_nil person.family_name
  end

  test "family name returns official name if no preferred name" do
    person = Person.new(official_given_name: "Jane", official_family_name: "Doe")

    assert_equal "Doe", person.official_family_name
    assert_nil person.preferred_family_name
    assert_equal "Doe", person.family_name
  end

  test "family name returns preferred name if specified" do
    person = Person.new(
      official_given_name: "Ariana",
      official_family_name: "Grande-Butera",
      preferred_family_name: "Grande"
    )

    assert_equal "Grande-Butera", person.official_family_name
    assert_equal "Grande", person.preferred_family_name
    assert_equal "Grande", person.family_name
  end

  test "implicit display name is returned if not set" do
    person = Person.new(
      official_given_name: "Eric",
      other_given_names: "Henry",
      official_family_name: "Liddell"
    )

    assert_nil person.read_attribute("display_name")
    assert_equal "Eric Liddell", person.display_name
  end

  test "explicit display name takes precedence" do
    person = Person.new(
      official_given_name: "Barack",
      other_given_names: "Hussein",
      official_family_name: "Obama",
      display_name: "Barack Obama II"
    )

    assert_equal "Barack Obama II", person.display_name
  end

  test "implicit display name gracefully handles no family name" do
    person = Person.new(official_given_name: "Prince")
    assert_nil person.read_attribute("display_name")

    assert_equal "Prince", person.display_name
  end

  test "implicit sort name is returned if not set" do
    person = Person.new(
      official_given_name: "Han",
      official_family_name: "Solo"
    )
    assert_nil person.read_attribute("sort_name")

    assert_equal "Solo, Han", person.sort_name
  end

  test "explicit sort name takes precedence" do
    person = Person.new(
      official_given_name: "Tupac",
      other_given_names: "Amaru",
      official_family_name: "Shakur",
      preferred_given_name: "2Pac",
      preferred_family_name: ""
    )
    assert_nil person.read_attribute("sort_name")
    assert_equal "2Pac", person.sort_name

    person.sort_name = "Shakur, Tupac"

    assert_equal "Shakur, Tupac", person.sort_name
  end

  test "implicit sort name gracefully handles no family name" do
    person = Person.new(preferred_given_name: "Ronaldinho")
    assert_nil person.read_attribute("sort_name")

    assert_equal "Ronaldinho", person.sort_name
  end

  test "can 'clear' an official family name" do
    person = Person.new(
      official_given_name: "Alicia",
      other_given_names: "Beth",
      official_family_name: "Moore",
      preferred_given_name: "P!nk",
      preferred_family_name: "",
      sort_name: "Pink"
    )

    assert_equal "Alicia", person.official_given_name
    assert_equal "P!nk", person.preferred_given_name
    assert_equal "P!nk", person.given_name

    assert_equal "Moore", person.official_family_name
    assert_equal "", person.preferred_family_name
    assert_equal "", person.family_name

    assert_equal "P!nk", person.display_name
  end
end
