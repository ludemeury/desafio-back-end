# frozen_string_literal: true

class FinancialMovementParser
  def self.parse(file_content)
    Rails.logger.info("#{Time.now.strftime('%F %T')} -  #{self}::#{__method__}")
    return unless file_content.is_a? String

    document_lines = file_content.lines

    Rails.logger.info("#{Time.now.strftime('%F %T')} -  #{self}::#{__method__} - #{document_lines.length}")

    document_lines.collect do |line|
      {
        kind: line[0],
        date: line[1..8],
        value: line[9..18],
        document: line[19..29],
        card: line[30..41],
        hour: line[42..47],
        shop_owner: line[48..61].to_s.strip,
        shop_name: line[62..79].to_s.strip
      }
    end
  end
end
