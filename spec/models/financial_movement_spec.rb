# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FinancialMovement, type: :model do
  before :each do
    owner = Owner.create(name: 'joao pereira', document: '48164028029')
    @shop = Shop.create(name: 'vendinha', owner: owner)
  end

  context 'Validations' do
    it 'is not valid without shop' do
      expect(FinancialMovement.create(kind: 1, done_at: Time.current, value: 595.32, card: '1234567')).to_not be_valid
    end

    it 'is valid with all valid data' do
      expect(FinancialMovement.create(kind: 1, done_at: Time.current, value: 595.32, card: '1234567',
                                      shop: @shop)).to be_valid
    end

    it 'is not valid if repeated' do
      params = { kind: 1, done_at: Time.current, value: 595.32, card: '1234567', shop: @shop }
      FinancialMovement.create(params)
      expect(FinancialMovement.create(params)).to_not be_valid
    end
  end
end
