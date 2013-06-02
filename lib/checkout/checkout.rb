module Checkout
  class Checkout
    def initialize(default_pricing_calculator = PricingStrategy)
      @calculator = default_pricing_calculator.new
      @scanned = []
    end

    def total
      @scanned.group_by{|item| item }.map(&:last).inject(0.0) do |total, items_basket|
        total + @calculator.calculate_price(items_basket.first, items_basket.size)
      end
    end

    def scan(item)
      @scanned << item
    end
  end
end