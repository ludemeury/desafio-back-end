# frozen_string_literal: true

class ImportFinancialMovementService
  attr_accessor :movements

  def initialize(movements)
    self.movements = movements
  end

  def execute
    Rails.logger.info("#{Time.now.strftime('%F %T')} -  #{self.class}::#{__method__}")
    return unless movements.present?

    Rails.logger.info("#{Time.now.strftime('%F %T')} -  #{self.class}::#{__method__} - #{movements.length}")
    import
  end

  private

  def owners_by_doc
    return @owners_by_doc if @owners_by_doc

    owner_docs = movements.collect { |e| e.dig(:shop, :owner, :document) }.compact.uniq.sort
    Rails.logger.info("#{Time.now.strftime('%F %T')} -  #{self.class}::#{__method__} - #{owner_docs}")
    @owners_by_doc = Owner.where(document: owner_docs).index_by(&:id)
  end

  def shops_by_name
    return @shops_by_name if @shops_by_name

    shop_names = movements.collect { |e| e.dig(:shop, :name) }.compact.uniq.sort
    Rails.logger.info("#{Time.now.strftime('%F %T')} -  #{self.class}::#{__method__} - #{shop_names}")
    @shops_by_name = Shop.where(name: shop_names).index_by(&:id)
  end

  def find_or_create_shop(movement)
    shop_name = movement.dig(:shop, :name)
    Rails.logger.info("#{Time.now.strftime('%F %T')} -  #{self.class}::#{__method__} - #{shop_name}")
    shops_by_name[shop_name] ||= Shop.create(name: shop_name, owner: find_or_create_owner(movement))
  end

  def find_or_create_owner(movement)
    document = movement.dig(:shop, :owner, :document)
    Rails.logger.info("#{Time.now.strftime('%F %T')} -  #{self.class}::#{__method__} - #{document}")
    owners_by_doc[document] ||= Owner.create(movement.dig(:shop, :owner))
  end

  def import
    Rails.logger.info("#{Time.now.strftime('%F %T')} -  #{self.class}::#{__method__}")
    movements.collect do |e|
      movement = FinancialMovement.create(
        kind: e[:kind],
        done_at: e[:done_at],
        value: e[:value],
        card: e[:card],
        shop: find_or_create_shop(e)
      )

      Rails.logger.info("#{Time.now.strftime('%F %T')} -  #{self.class}::#{__method__} - #{movement.id} - #{movement.shop_id} - #{movement.shop&.name} - #{movement.errors.messages}")

      movement
    end
  end
end
