# frozen_string_literal: true

class FinancialMovementsController < ApplicationController
  before_action :set_financial_movement, only: %i[destroy]

  # GET /financial_movements
  def index
    Rails.logger.info("#{Time.now.strftime('%F %T')} -  #{self.class}::#{__method__}")
    @shops = Shop.all.includes(financial_movements: [shop: [:owner]])
  end

  # POST /financial_movements/upload
  def upload
    Rails.logger.info("#{Time.now.strftime('%F %T')} -  #{self.class}::#{__method__}")
    uploaded_file = params[:file]
    if uploaded_file&.content_type == 'text/plain'
      file_content = uploaded_file.read
      movements = FinancialMovementParser.parse(file_content)
      ImportFinancialMovementService.new(movements).execute
    end
    redirect_to root_path
  end

  # DELETE /financial_movements/1
  def destroy
    @financial_movement.destroy
    redirect_to financial_movements_url
  end

  private

  def set_financial_movement
    @financial_movement = FinancialMovement.find(params[:id])
  end
end
