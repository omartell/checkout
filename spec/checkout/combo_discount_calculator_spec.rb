require 'spec_helper'

module Checkout
  describe ComboDiscountCalculator do
    it "returns zero as the discount if there are no combo discounts for the set" do
      rule = { "A" => { unit_price: 10, offers: [] } }
      ComboDiscountCalculator.new(rule).discount("A", ["A"]).should be 0.0
    end

    it "returns the discount based on the combo discount from the pricing rule" do
      rule = { "A" => { unit_price: 10, offers: [ { combo_discount: "A", qualifying_combo: "DDD" } ] } }
      ComboDiscountCalculator.new(rule).discount("A", ["D", "D", "D", "A"]).should be 10
    end
  end
end