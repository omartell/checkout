module Checkout
  class ComboDiscountCalculator
    def initialize(rules = RULES, calculator = PriceCalculator)
      @rules  = rules
      @calculator = calculator.new(rules)
    end

    def discount(product_id, basket)
      fetcher = PriceFetcher.for(product_id, rules)
      combo_matched_basket = combos_for_basket(fetcher, basket)

      if combo_matched_basket
        product_discount = combo_matched_basket.discount
        @calculator.calculate(product_discount, product_discount.size)
      else
        0.0
      end
    end

    private
    attr_reader :rules

    def combos_for_basket(fetcher, basket)
      fetcher.combos.find do |combo|
        grouped_basket(basket).include?(combo.qualifier)
      end
    end

    def grouped_basket(basket)
      basket.group_by{ |item| item }.flat_map(&:last).join("")
    end
  end
end