class Person < ApplicationRecord
  has_many :sis_records
  
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
