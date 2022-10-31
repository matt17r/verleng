module Sycamore # class Sycamore::Contact
  class Contact < ApplicationRecord
    scope :active, -> { where(deleted_at: nil) }
    scope :deleted, -> { where.not(deleted_at: nil) }

    belongs_to :person, optional: true

    validates :id, presence: true, uniqueness: true # using Sycamore's unique ID instead of having PostgreSQL generate one
  end
end
