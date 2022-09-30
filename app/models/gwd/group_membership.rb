module GWD # class GWD::GroupMembership
  class GroupMembership < ApplicationRecord
    before_create do
      self.id = Digest::UUID.uuid_v4
    end

    belongs_to :group
    belongs_to :member, :polymorphic => true

    enum role: {
      owner: "owner",
      manager: "manager",
      member: "member"
    }

    validates :group_id, presence: true
    validates :member_id, presence: true
    validates :member_type, presence: true
    validates :email, presence: true
    validates :role, presence: true
  end
end
