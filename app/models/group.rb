class Group < ApplicationRecord
  has_many :group_memberships, dependent: :destroy
  has_many :members, through: :group_memberships, source: :person
  
  validates :name, presence: true
end
