module Checkout
  class Checkout
    def initialize(pricing_rules)
      @pricing_rules = pricing_rules
      @scanned = []
    end

    def total
      @scanned.group_by{|item| item }.map(&:last).inject(0.0) do |total, items_basket|
        pricing_rule      = @pricing_rules.fetch(items_basket.first)
        discount_quantity = pricing_rule[:discount_quantity]

        if discount_quantity && discount_quantity == items_basket.size
          price_for_similar = pricing_rule.fetch(:discount_price)
        else
          price_for_similar = pricing_rule.fetch(:unit_price) * items_basket.size
        end

        total + price_for_similar
      end
    end

    def scan(item)
      @scanned << item
    end
  end
end