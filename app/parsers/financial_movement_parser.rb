# frozen_string_literal: true

class FinancialMovementParser
  def self.parse(file_content)
    Rails.logger.info("#{Time.now.strftime('%F %T')} -  #{self}::#{__method__}")
    return unless file_content.is_a? String

    document_lines = file_content.lines

    Rails.logger.info("#{Time.now.strftime('%F %T')} -  #{self}::#{__method__} - #{document_lines.length}")

    timezone = Time.find_zone('Brasilia')

    document_lines.collect do |line|
      date = line[1..8]
      hour = line[42..47]
      done_at = timezone.parse("#{date}#{hour}")
      {
        kind: line[0],
        done_at: done_at,
        value: line[9..18].to_f / 100,
        card: line[30..41],
        shop: {
          name: line[62..79].to_s.strip,
          owner: {
            document: line[19..29],
            name: line[48..61].to_s.strip
          }
        }
      }
    end
  end
end
