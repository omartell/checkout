class PricingStrategy

  RULES = {
    "A" => { unit_price: 50, discount_price: 130, discount_quantity: 3 },
    "B" => { unit_price: 30, discount_price: 45,  discount_quantity: 2 },
    "C" => { unit_price: 20 },
    "D" => { unit_price: 15 }
  }

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
    else
      product_rules.fetch(:unit_price) * quantity
    end
  end

end