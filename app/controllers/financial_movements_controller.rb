class FinancialMovementsController < ApplicationController
  def index
    Rails.logger.info("#{Time.now.strftime('%F %T')} -  #{self.class}::#{__method__}")
    @financial_movements = FinancialMovement.all
  end

  def upload
    Rails.logger.info("#{Time.now.strftime('%F %T')} -  #{self.class}::#{__method__}")
    uploaded_file = params[:file]
    if uploaded_file.content_type == 'text/plain'
      file_content = uploaded_file.read.force_encoding('UTF-8')
      # file_content.gsub!(/\r\n?/, "\n")
      movements = FinancialMovementParser.parse(file_content)
      ImportFinancialMovementService.new(movements).execute
    end
    redirect_to root_path
  end
end
