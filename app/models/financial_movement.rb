# frozen_string_literal: true

class FinancialMovement < ApplicationRecord
  OUTPUT_OPERATIONS = [2, 3, 9].freeze
  belongs_to :shop

  def output?
    OUTPUT_OPERATIONS.include? kind
  end
end
