class Person < ApplicationRecord
  has_many :contacts_family_relationships, foreign_key: "student_id", class_name: "FamilyRelationship", dependent: :destroy
  has_many :contacts, through: :contacts_family_relationships, source: :contact

  has_many :students_family_relationships, foreign_key: "contact_id", class_name: "FamilyRelationship", dependent: :destroy
  has_many :students, through: :students_family_relationships, source: :student

  has_many :directory_users, class_name: "GWD::User"
  has_many :directory_contacts, class_name: "GWD::EmailContact"

  has_many :sis_students, class_name: "Sycamore::Student"
  has_many :sis_contacts, class_name: "Sycamore::Contact"

  validates :given_name, presence: true

  def self.sorted_by_name
    Person.all.sort_by(&:sort_name)
  end

  def display_name
    super || "#{given_name} #{family_name}".strip
  end

  def email
    school_email || personal_email
  end

  def family_name
    preferred_family_name || official_family_name
  end

  def given_name
    preferred_given_name || official_given_name
  end

  def sort_name
    super || [family_name, given_name].reject(&:blank?).join(", ")
  end
end
