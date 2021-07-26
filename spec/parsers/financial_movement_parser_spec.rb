# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FinancialMovementParser do
  before :each do
    @content_file = File.read('CNAB.txt')
  end

  context 'parse' do
    it 'return must be a empty list when content file is invalid' do
      expect(FinancialMovementParser.parse(nil)).to match_array([])
    end

    it 'return must be a empty list when document is invalid' do
      expect(FinancialMovementParser.parse('00000000')).to match_array([])
    end

    it 'the input is the same size as the output' do
      expect(FinancialMovementParser.parse(@content_file).length).to eq @content_file.lines.length
    end
  end
end
