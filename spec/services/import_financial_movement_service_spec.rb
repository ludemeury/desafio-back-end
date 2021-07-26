# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImportFinancialMovementService do
  before :each do
    @movements_input = FinancialMovementParser.parse(File.read('CNAB.txt'))
    @movements_output = ImportFinancialMovementService.new(@movements_input).execute
  end

  context 'import' do
    it 'all movements were imported' do
      expect(@movements_output.length).to eq @movements_input.length
    end

    it 'all shops were imported' do
      inputs = @movements_input.collect { |e| e.dig(:shop, :name) }.compact.uniq.sort
      outputs = @movements_output.collect(&:shop).select(&:persisted?).collect(&:name).compact.uniq.sort
      expect(outputs).to eq inputs
    end

    it 'all owners were imported' do
      inputs = @movements_input.collect { |e| e.dig(:shop, :owner, :name) }.compact.uniq.sort
      outputs = @movements_output.collect(&:shop).compact.select(&:persisted?).collect(&:owner).compact.select(&:persisted?).collect(&:name).compact.uniq.sort
      expect(outputs).to eq inputs
    end

    it 'all movements were imported with existing shops' do
      # import again
      FinancialMovement.destroy_all
      @movements_output = ImportFinancialMovementService.new(@movements_input).execute

      inputs = @movements_input.collect { |e| e.dig(:shop, :name) }.compact.uniq.sort
      outputs = @movements_output.collect(&:shop).compact.select(&:persisted?).collect(&:name).compact.uniq.sort
      expect(outputs).to eq inputs
    end

    it 'all movements were imported wihout shop' do
      # import again
      FinancialMovement.destroy_all
      Shop.destroy_all
      @movements_output = ImportFinancialMovementService.new(@movements_input).execute

      inputs = @movements_input.collect { |e| e.dig(:shop, :name) }.compact.uniq.sort
      outputs = @movements_output.collect(&:shop).compact.select(&:persisted?).collect(&:name).compact.uniq.sort
      expect(outputs).to eq inputs
    end
  end
end
