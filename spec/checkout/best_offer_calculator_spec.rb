require 'spec_helper'

module Checkout
  describe BestOfferCalculator do
    context "Discount Quantity on the Pricing Rule" do

      it "calculates a discount price for a product if the basket quantity matches the rule discount quantity" do
        pricing_rule = {
          "B" => { unit_price: 15, offers: [ { discount: 0.4, quantity: 2 } ] }
        }
        subject = BestOfferCalculator.new(pricing_rule)

        subject.calculate("B", 2).should eq 30*0.4
      end

      it "chooses the best discounts based on the remaining quantity of items" do
        pricing_rule = {
          "B" => { unit_price: 30, offers: [ { discount: 0.15, quantity: 2 }, { discount: 0.15, quantity: 3 } ] }
        }
        subject = BestOfferCalculator.new(pricing_rule)

        subject.calculate("B", 5).should eq 60*0.15+ 90*0.15
      end

      it "applies the discount for the items that match the discount quantity and the basic price for all the other items" do
        pricing_rule = {
          "B" => { unit_price: 15, offers: [ { discount: 0.45, quantity: 3 } ] }
        }
        subject = BestOfferCalculator.new(pricing_rule)

        subject.calculate("B", 5).should eq 45 * 0.45
      end

    end
  end
end