module Checkout
  class Checkout
    def initialize(default_pricing_calculator = PriceCalculator)
      @calculator = default_pricing_calculator.new
      @scanned = []
    end

    def total
      @scanned.group_by{|item| item }.map(&:last).inject(0.0) do |total, items_basket|
        product_id, quantity = items_basket.first, items_basket.size
        total + @calculator.calculate(product_id, quantity)
      end
    end

    def scan(item)
      @scanned << item
    end
  end
end