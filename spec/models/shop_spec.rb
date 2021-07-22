# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shop, type: :model do
  before :each do
    @owner = Owner.create(name: 'joao pereira', document: '48164028029')
  end

  context 'Validations' do
    it 'is not valid without owner' do
      expect(Shop.create(name: 'vendinha')).to_not be_valid
    end

    it 'is not valid without name' do
      expect(Shop.create(owner: @owner)).to_not be_valid
    end

    it 'is not valid with repeated name in the same owner' do
      Shop.create(name: 'vendinha', owner: @owner)
      expect(Shop.create(name: 'vendinha', owner: @owner)).to_not be_valid
    end

    it 'is valid with all valid data' do
      expect(Shop.create(name: 'vendinha', owner: @owner)).to be_valid
    end
  end
end
