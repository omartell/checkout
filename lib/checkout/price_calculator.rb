module Checkout
  class PriceCalculator

    def initialize(rules = RULES)
      @rules = rules
    end

    def calculate(product_id, quantity)
      product_rule = PriceFetcher.for(product_id, rules)
      product_rule.unit_price * quantity
    end

    private
    attr_reader :rules

  end
end