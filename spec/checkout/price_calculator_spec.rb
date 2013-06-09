require 'spec_helper'

module Checkout
  describe PriceCalculator do

    class NoRulesForProductError < Exception; end;

    it "calculates the price for a product" do
      pricing_rule = { "A" => { unit_price: 10, offers: [] } }
      subject      = PriceCalculator.new(pricing_rule)

      subject.calculate("A", 1).should eq 10
    end
  end
end