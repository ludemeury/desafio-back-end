# frozen_string_literal: true

class Owner < ApplicationRecord
  validates :name,
            length: { within: 1..255 },
            presence: true

  validates :document,
            presence: true,
            uniqueness: true
end
