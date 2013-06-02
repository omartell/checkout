require 'spec_helper'

describe Checkout::Checkout do

  # Item  Price   Offer
  # --------------------------
  # A     50       3 for 130
  # B     30       2 for 45
  # C     20
  # D     15

  RULES = {
    "A" => { unit_price: 50,
      offers: [
        { discount_price: 130, discount_quantity: 3 }
      ]
    },
    "B" => { unit_price: 30,
      offers: [
        { discount_price: 45, discount_quantity: 2 }
      ]
    },
    "C" => { unit_price: 20 },
    "D" => { unit_price: 15 },
    "E" => { unit_price: 10, deal_name: "2x1" },
    "F" => {
      unit_price: 50,
      offers: [
        { discount_price: 130, discount_quantity: 3 },
        { discount_price: 90, discount_quantity: 2 }
      ]
    }
  }

  def price(goods)
    co = Checkout::Checkout.new
    goods.split(//).each { |item| co.scan(item) }
    co.total
  end

  it "returns zero when there are no products in the basket" do
    price("").should eq 0.0
  end

  context "No offers exist" do
    it "returns the total for a basket with just one item" do
      price("C").should eq 20.0
    end

    it "returns the total for a basket with two items" do
      price("CD").should eq 35.0
    end
  end

  context "Offers based on quantity" do
    it "doesn't apply discount when the items in the basket don't match the discount quantity" do
      price("A").should eq 50.0
      price("AA").should eq 100.0
    end

    it "applies the discount when the quantity of items in the basket matches the discount quantity" do
      price("AAA").should eq 130.0
    end

    it "applies different discounts" do
      price("AAABB").should eq 175.0
    end

    it "applies discounts or unit prices" do
      price("AAABBCD").should eq 210.0
    end

    it "applies discounts when similar items are not in order" do
      price("CABABAD").should eq 210.0
    end

    context "Basket quantity is higher than discount quantity" do
      it "applies the discount for the discount quantity and the basic price for the rest of the items" do
        price("AAAAA").should eq 230.0
      end
    end
  end

  context "A product can have different offers associated with it" do
    it "calculates the price of an item with more than one offer" do
      price("FFFFF").should eq 220.0
    end
  end

  context "Deals" do
    it "caculates the price based on the deal name" do
      price("EE").should eq 10
    end
  end

end