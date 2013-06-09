module Checkout
  class PricingStrategy

    def initialize(rules = RULES)
      @rules = rules
    end

    def calculate_price(product_id, quantity)
      product_rules = rules.fetch(product_id) do
        raise NoRulesForProductError.new(product_id)
      end

      best_offer = best_offer_from(product_rules, quantity)

      if best_offer
        remaining_quantity = quantity - best_offer[:quantity]
        best_offer.fetch(:price) + calculate_price(product_id, remaining_quantity)
      else
        0
      end
    end

    private
    attr_reader :rules

    def best_offer_from(product_rules, quantity)
      Array(product_rules).select do |o|
        o[:quantity] <= quantity
      end.max do |a, b|
        a[:quantity] <=> b[:quantity]
      end
    end

  end
end