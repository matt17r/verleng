class DirectoryRecord < ApplicationRecord
  belongs_to :person
  
  validates :directory_id, presence: true
  validates :email, presence: true
  validates :org_unit, presence: true
  validates :email_aliases, length: { minimum: 0, allow_nil: false, message: "can't be nil" }
end
