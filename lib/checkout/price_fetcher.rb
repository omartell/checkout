 module Checkout
  class PriceFetcher
    ProductOffer = Struct.new(:discount, :quantity)
    ComboOffer = Struct.new(:qualifier, :discount)

    def self.for(product_id, pricing_rules)
      pricing_rule = pricing_rules.fetch(product_id) do
        raise NoRulesForProductError.new(product_id)
      end
      new(pricing_rule)
    end

    def initialize(pricing_rule)
      @pricing_rule = pricing_rule
    end

    def combos
      pricing_rule.fetch(:offers).map do |p|
        if p[:qualifying_combo]
          ComboOffer.new(p.fetch(:qualifying_combo), p.fetch(:combo_discount))
        end
      end.compact
    end

    def offers
      pricing_rule.fetch(:offers).map do |p|
        if p[:discount]
          ProductOffer.new(p.fetch(:discount), p.fetch(:quantity))
        end
      end.compact
    end

    def unit_price
      pricing_rule.fetch(:unit_price)
    end

    private
    attr_reader :pricing_rule

  end
end