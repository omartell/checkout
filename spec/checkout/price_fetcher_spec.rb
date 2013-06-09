require 'spec_helper'

module Checkout
  describe PriceFetcher do
    it "throws an exception for products with no pricing rule" do
      pricing_rule = { "A" => { unit_price: 10, offers: [] } }
      subject      = PriceCalculator.new(pricing_rule)

      expect{ subject.calculate("blah", 1) }.to raise_error NoRulesForProductError
    end
  end
end