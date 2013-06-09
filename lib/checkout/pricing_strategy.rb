module Checkout

  class PricingRuleResolver
    ProductOffer = Struct.new(:price, :quantity)

    def self.for(product_id, pricing_rules)
      pricing_rule = pricing_rules.fetch(product_id) do
        raise NoRulesForProductError.new(product_id)
      end
      new(pricing_rule)
    end

    def initialize(pricing_rule)
      @pricing_rule = pricing_rule
    end

    def prices
      pricing_rule.map do |p|
        ProductOffer.new(p.fetch(:price), p.fetch(:quantity))
      end
    end

    private
    attr_reader :pricing_rule

  end

  class PricingStrategy

    def initialize(rules = RULES)
      @rules = rules
    end

    def calculate_price(product_id, quantity)
      product_rule = PricingRuleResolver.for(product_id, rules)
      best_offer   = best_offer_from(product_rule, quantity)

      if best_offer
        remaining_quantity = quantity - best_offer.quantity
        best_offer.price + calculate_price(product_id, remaining_quantity)
      else
        0
      end
    end

    private
    attr_reader :rules

    def best_offer_from(product_rule, basket_quantity)
      product_rule.prices.select do |o|
        o.quantity <= basket_quantity
      end.max do |a, b|
        a.quantity <=> b.quantity
      end
    end

  end
end