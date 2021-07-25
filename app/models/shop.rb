# frozen_string_literal: true

class Shop < ApplicationRecord
  belongs_to :owner

  validates :name,
            length: { within: 1..255 },
            presence: true,
            uniqueness: { scope: %i[owner_id] }

  has_many :financial_movements

  def balance
    financial_movements.sum { |e| e.output? ? -e.value : e.value }.round(2)
  end
end
