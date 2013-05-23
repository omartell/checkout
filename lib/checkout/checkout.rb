module Checkout
  class Checkout
    def initialize(rules)
      @rules = rules
      @products_scanned = []
    end

    def total
      @products_scanned.inject(0.0) do |memo, item|
        memo + @rules.fetch(item).fetch(:unit_price)
      end
    end

    def scan(item)
      @products_scanned << item
    end
  end
end