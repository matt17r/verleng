module GWD # class GWD::Group
  class Group < ApplicationRecord
    scope :active, -> { where(deleted_at: nil) }
    scope :deleted, -> { where.not(deleted_at: nil) }

    has_many :group_memberships, as: :member
    has_many :groups, through: :group_memberships, source: :group

    has_many :memberships, class_name: "GWD::GroupMembership", foreign_key: "group_id"
    has_many :member_users, through: :memberships, source: :member, source_type: "GWD::User"
    has_many :member_groups, through: :memberships, source: :member, source_type: "GWD::Group"
    has_many :member_contacts, through: :memberships, source: :member, source_type: "GWD::EmailContact"

    validates :id, presence: true, uniqueness: true # using Google's unique ID instead of having PostgreSQL generate one
    validates :etag, presence: true
    validates :name, presence: true
    validates :email, presence: true
  end
end
