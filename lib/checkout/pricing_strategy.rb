module Checkout
  class PricingStrategy

    def initialize(rules = RULES)
      @rules = rules
    end

    def calculate_price(product, quantity)
      product_rules = @rules.fetch(product) do
        raise NoRulesForProductError.new(product)
      end
      discount_quantity = product_rules[:discount_quantity]

      if discount_quantity && discount_quantity == quantity
        product_rules.fetch(:discount_price)
      elsif product_rules[:deal_name] == "2x1"
        product_rules.fetch(:unit_price)
      else
        product_rules.fetch(:unit_price) * quantity
      end
    end

  end
end