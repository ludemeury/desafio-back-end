# frozen_string_literal: true

class Owner < ApplicationRecord
  validates :name,
            length: { within: 1..255 },
            presence: true

  validates :document,
            presence: true,
            uniqueness: true

  validate :document_valid

  has_many :shops

  private

  def document_valid
    valid = CPF.valid?(document).present?
    Rails.logger.info("#{Time.now.strftime('%F %T')} -  #{self.class}::#{__method__} - #{document} - #{valid}")

    return true if valid

    errors.add(:document, 'invalid')
  end
end
