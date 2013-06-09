require 'spec_helper'

module Checkout
  describe PriceCalculator do

    class NoRulesForProductError < Exception; end;

    it "calculates the price for a product" do
      pricing_rule = { "A" => { unit_price: 10, offers: [] } }
      subject      = PriceCalculator.new(pricing_rule)

      subject.calculate("A", 1).should eq 10
    end

    it "throws an exception for products with no pricing rule" do
      pricing_rule = { "A" => { unit_price: 10, offers: [] } }
      subject      = PriceCalculator.new(pricing_rule)

      expect{ subject.calculate("blah", 1) }.to raise_error NoRulesForProductError
    end

    context "Discount Quantity on the Pricing Rule" do

      it "calculates a discount price for a product if the basket quantity matches the rule discount quantity" do
        pricing_rule = {
          "B" => { unit_price: 15, offers: [ { price: 25, quantity: 2 } ] }
        }
        subject = PriceCalculator.new(pricing_rule)

        subject.calculate("B", 2).should eq 25
      end

      it "chooses the best discounts based on the remaining quantity of items" do
        pricing_rule = {
          "B" => { unit_price: 30, offers: [ { price: 50, quantity: 2 }, { price: 75, quantity: 3 } ] }
        }
        subject = PriceCalculator.new(pricing_rule)

        subject.calculate("B", 5).should eq 125
      end

      it "applies the discount for the items that match the discount quantity and the basic price for all the other items" do
        pricing_rule = {
          "B" => { unit_price: 15, offers: [ { price: 25, quantity: 3 } ] }
        }
        subject = PriceCalculator.new(pricing_rule)

        subject.calculate("B", 5).should eq 55
      end

    end
  end
end