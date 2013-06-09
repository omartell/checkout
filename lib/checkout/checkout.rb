module Checkout
  class Checkout
    def initialize(default_pricing_calculator = PriceCalculator, best_offer_calculator = BestOfferCalculator)
      @normal_price_calculator = default_pricing_calculator.new
      @offer_calculator = best_offer_calculator.new
      @scanned = []
    end

    def total
      total_withouth_offers - offers
    end

    def scan(item)
      @scanned << item
    end

    private

    def offers
      @scanned.group_by{|item| item }.map(&:last).inject(0.0) do |total, items_basket|
        product_id, quantity = items_basket.first, items_basket.size
        total + @offer_calculator.calculate(product_id, quantity)
      end
    end

    def total_withouth_offers
      @scanned.group_by{|item| item }.map(&:last).inject(0.0) do |total, items_basket|
        product_id, quantity = items_basket.first, items_basket.size
        charge = @normal_price_calculator.calculate(product_id, quantity)
        total + charge
      end
    end

  end
end