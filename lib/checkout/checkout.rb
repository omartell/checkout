module Checkout
  class Checkout
    def initialize(pricing_rules)
      @pricing_rules    = pricing_rules
      @products_scanned = []
    end

    def total
      @products_scanned.inject(0.0) do |total, item|
        total + @pricing_rules.fetch(item).fetch(:unit_price)
      end
    end

    def scan(item)
      @products_scanned << item
    end
  end
end