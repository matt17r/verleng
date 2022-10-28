module GWD # class GWD::EmailContact
  class EmailContact < ApplicationRecord
    scope :active, -> { where(deleted_at: nil) }
    scope :deleted, -> { where.not(deleted_at: nil) }

    belongs_to :person, optional: true

    has_many :group_memberships, as: :member
    has_many :groups, through: :group_memberships, source: :group

    validates :id, presence: true, uniqueness: true # using Google's unique ID instead of having PostgreSQL generate one
    validates :email, presence: true, external_email: true
  end
end
