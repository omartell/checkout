module Checkout
  class BestOfferCalculator
    def initialize(rules = RULES, calculator = PriceCalculator)
      @rules = rules
      @calculator = calculator.new(rules)
    end

    def discount(product_id, quantity)
      product_rule = PriceFetcher.for(product_id, rules)
      offer = offer_matching_basket(product_rule, quantity)

      if offer
        @calculator.calculate(product_id, offer.quantity) * offer.discount +
        discount(product_id, quantity - offer.quantity)
      else
        0
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