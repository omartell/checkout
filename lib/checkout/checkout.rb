module Checkout
  class Checkout
    def initialize(default_pricing_calculator = PriceCalculator,
      best_offer_calculator = BestOfferCalculator,
      combo_discount_calculator = ComboDiscountCalculator)

      @normal_price_calculator = default_pricing_calculator.new
      @offer_calculator = best_offer_calculator.new
      @combo_calculator = combo_discount_calculator.new
      @scanned = []
    end

    def total
      total_withouth_offers - direct_discounts - combo_discounts
    end

    def scan(item)
      @scanned << item
    end

    private

    def combo_discounts
      grouped_items.inject(0.0) do |total, items_basket|
        product_id, quantity = items_basket.first, items_basket.size
        total + @combo_calculator.discount(product_id, @scanned)
      end
    end

    def direct_discounts
      grouped_items.inject(0.0) do |total, items_basket|
        product_id, quantity = items_basket.first, items_basket.size
        total + @offer_calculator.discount(product_id, quantity)
      end
    end

    def total_withouth_offers
      grouped_items.inject(0.0) do |total, items_basket|
        product_id, quantity = items_basket.first, items_basket.size
        charge = @normal_price_calculator.calculate(product_id, quantity)
        total + charge
      end
    end

    def grouped_items
      @scanned.group_by{|item| item }.map(&:last)
    end

  end
end