# frozen_string_literal: true

class ImportFinancialMovementService
  attr_accessor :movements

  def initialize(movements)
    self.movements = movements
  end

  def execute
    Rails.logger.info("#{Time.now.strftime('%F %T')} -  #{self.class}::#{__method__}")
    return [] unless movements.present?

    Rails.logger.info("#{Time.now.strftime('%F %T')} -  #{self.class}::#{__method__} - #{movements.length}")
    import
  end

  private

  def import
    Rails.logger.info("#{Time.now.strftime('%F %T')} -  #{self.class}::#{__method__}")
    movements.collect do |e|
      params = e.slice(:kind, :done_at, :value, :card)
      shop = find_or_create_shop(e)
      Rails.logger.info("#{Time.now.strftime('%F %T')} -  #{self.class}::#{__method__} - #{shop&.id}")
      params[:shop] = shop
      movement = FinancialMovement.create(params)

      Rails.logger.info("#{Time.now.strftime('%F %T')} -  #{self.class}::#{__method__} - #{movement.id} - #{movement.shop_id} - #{movement.shop&.name} - #{movement.errors.messages}")

      movement
    end
  end

  def owners_by_doc
    return @owners_by_doc if @owners_by_doc

    owner_docs = movements.collect { |e| e.dig(:shop, :owner, :document) }.compact.uniq.sort
    Rails.logger.info("#{Time.now.strftime('%F %T')} -  #{self.class}::#{__method__} - #{owner_docs}")
    @owners_by_doc = Owner.where(document: owner_docs).includes(:shops).index_by(&:document)
  end

  def shops_by_owner
    @shops_by_owner ||= {}
  end

  def find_or_create_shop(movement)
    name = movement.dig(:shop, :name)
    document = movement.dig(:shop, :owner, :document)
    Rails.logger.info("#{Time.now.strftime('%F %T')} -  #{self.class}::#{__method__} - #{name} - #{document}")
    owner = find_or_create_owner(movement)
    shops_by_owner[document] ||= owner.shops.index_by(&:name)
    shops_by_owner[document][name] ||= Shop.create(name: name, owner: owner)
  end

  def find_or_create_owner(movement)
    document = movement.dig(:shop, :owner, :document)
    Rails.logger.info("#{Time.now.strftime('%F %T')} -  #{self.class}::#{__method__} - #{document}")
    owners_by_doc[document] ||= Owner.create(movement.dig(:shop, :owner))
  end
end
