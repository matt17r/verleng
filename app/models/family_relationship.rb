class FamilyRelationship < ApplicationRecord
  belongs_to :contact, foreign_key: "contact_id", class_name: "Person"
  belongs_to :student, foreign_key: "student_id", class_name: "Person"
end
