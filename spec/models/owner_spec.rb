# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Owner, type: :model do
  context 'Validations' do
    it 'is not valid with invalid document' do
      expect(Owner.create(name: 'joao pereira', document: '12345')).to_not be_valid
    end

    it 'is not valid without a document' do
      expect(Owner.create(name: 'maria de souza')).to_not be_valid
    end

    it 'is not valid without an name' do
      expect(Owner.create(document: '83330201002')).to_not be_valid
    end

    it 'is not valid with repeated document' do
      Owner.create(name: 'joao pereira', document: '48164028029')
      expect(Owner.create(name: 'joao pereira', document: '48164028029')).to_not be_valid
    end

    it 'is valid with all valid data' do
      expect(Owner.create(name: 'joao pereira', document: '48164028029')).to be_valid
    end
  end
end
