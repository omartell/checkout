module Checkout
  class PricingStrategy

    def initialize(rules = RULES)
      @rules = rules
    end

    def calculate_price(product, quantity)
      product_rules = rules.fetch(product) do
        raise NoRulesForProductError.new(product)
      end

      best_offer = best_offer_from(product_rules, quantity)

      if best_offer
        remaining_quantity = quantity - best_offer[:discount_quantity]
        best_offer.fetch(:discount_price) + calculate_price(product, remaining_quantity)
      elsif product_rules[:deal_name] == "2x1"
        product_rules.fetch(:unit_price)
      else
        product_rules.fetch(:unit_price) * quantity
      end
    end

    private
    attr_reader :rules

    def best_offer_from(product_rules, quantity)
      product_rules.fetch(:offers){ [] }.select do |o|
        o[:discount_quantity] <= quantity
      end.max do |a, b|
        a[:discount_quantity] <=> b[:discount_quantity]
      end
    end

  end
end