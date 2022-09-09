class SISRecord < ApplicationRecord
  belongs_to :person
  
  enum record_type: {
    student: "student",
    staff: "staff",
    contact: "contact"
  }
  
  validates :record_type, presence: true
  validates :sis_identifier, presence: true
  
  def sis_identifier
    code || sis_id
  end
end
