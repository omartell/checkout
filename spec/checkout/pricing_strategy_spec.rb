require 'spec_helper'

module Checkout
  describe PricingStrategy do

    class NoRulesForProductError < Exception; end;

    it "calculates the price for a product" do
      pricing_rule = { "A" => { unit_price: 10 } }
      subject      = PricingStrategy.new(pricing_rule)

      subject.calculate_price("A", 1).should eq 10
    end

    it "throws an exception for products with no pricing rule" do
      pricing_rule = { "A" => { unit_price: 10 } }
      subject      = PricingStrategy.new(pricing_rule)

      expect{ subject.calculate_price("blah", 1) }.to raise_error NoRulesForProductError
    end

    it "calculates a discount price for a product if the basket quantity matches the rule discount quantity" do
      pricing_rule = {
        "B" => { unit_price: 15, discount_price: 25, discount_quantity: 2 }
      }
      subject = PricingStrategy.new(pricing_rule)

      subject.calculate_price("B", 2).should eq 25
    end

    it "knows how to calculate the price based on the deal name" do
      pricing_rule = {
        "C" => { unit_price: 15, deal_name: "2x1" }
      }

      subject = PricingStrategy.new(pricing_rule)

      subject.calculate_price("C", 2).should eq 15
    end
  end
end