module Checkout

  class PriceFetcher
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

    def offers
      pricing_rule.fetch(:offers).map do |p|
        ProductOffer.new(p.fetch(:price), p.fetch(:quantity))
      end
    end

    def unit_price
      pricing_rule.fetch(:unit_price)
    end

    private
    attr_reader :pricing_rule

  end

  class PriceCalculator

    def initialize(rules = RULES)
      @rules = rules
    end

    def calculate(product_id, quantity)
      product_rule = PriceFetcher.for(product_id, rules)
      offer = offer_matching_basket(product_rule, quantity)

      if offer
        offer.price + calculate(product_id, quantity - offer.quantity)
      else
        product_rule.unit_price * quantity
      end
    end

    private
    attr_reader :rules

    def offer_matching_basket(product_rule, basket_quantity)
      product_rule.offers.select do |o|
        o.quantity <= basket_quantity
      end.max do |a, b|
        a.quantity <=> b.quantity
      end
    end

  end
end