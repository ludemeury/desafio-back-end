class FinancialMovementsController < ApplicationController
  def index
    Rails.logger.info("#{Time.now.strftime('%F %T')} -  #{self.class}::#{__method__}")
    @financial_movements = FinancialMovement.all
  end

  def upload
    Rails.logger.info("#{Time.now.strftime('%F %T')} -  #{self.class}::#{__method__}")
    uploaded_file = params[:file]
    p uploaded_file.class
    if uploaded_file.content_type == 'text/plain'
      file_content = uploaded_file.read
      p file_content.class
      # file_content.gsub!(/\r\n?/, "\n")
      # line_num=0
      # file_content.each_line do |line|
      #   p "#{line_num += 1} #{line}"
      # end
      hash = FinancialMovementParser.parse(file_content)
      p hash
    end
    redirect_to root_path
  end
end
