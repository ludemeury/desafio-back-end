# frozen_string_literal: true

class Shop < ApplicationRecord
  belongs_to :owner

  validates :name,
            length: { within: 1..255 },
            presence: true,
            uniqueness: { scope: %i[owner_id] }
end
