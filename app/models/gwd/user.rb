module GWD # class GWD::User
  class User < ApplicationRecord
    scope :active, -> { where(suspended: false, deleted_at: nil) }
    scope :suspended, -> { where(suspended: true, deleted_at: nil) }
    scope :deleted, -> { where.not(deleted_at: nil) }

    belongs_to :person, optional: true

    has_many :group_memberships, as: :member
    has_many :groups, through: :group_memberships, source: :group

    validates :id, presence: true, uniqueness: true # using Google's unique ID instead of having PostgreSQL generate one
    validates :email, presence: true
    validates :etag, presence: true
    validates :org_unit, presence: true
    validates :suspended, exclusion: [nil] # https://guides.rubyonrails.org/active_record_validations.html#presence
    validates :email_aliases, length: { minimum: 0, allow_nil: false, message: "can't be nil" }
  end
end
