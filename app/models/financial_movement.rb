# frozen_string_literal: true

class FinancialMovement < ApplicationRecord
  OUTPUT_OPERATIONS = [2, 3, 9].freeze
  belongs_to :shop

  validates :value,
            numericality: { greater_than: 0 },
            presence: true,
            uniqueness: { scope: %i[shop_id kind done_at card] }

  def output?
    OUTPUT_OPERATIONS.include? kind
  end
end
