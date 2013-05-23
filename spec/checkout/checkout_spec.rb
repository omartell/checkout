require 'spec_helper'

describe Checkout::Checkout do

  # Item  Price   Offer
  # --------------------------
  # A     50       3 for 130
  # B     30       2 for 45
  # C     20
  # D     15

  let(:rules) do
    {
      "A" => { unit_price: 50, discount_price: 130, discount_quantity: 3 },
      "B" => { unit_price: 30, discount_price: 45,  discount_quantity: 2 },
      "C" => { unit_price: 20 },
      "D" => { unit_price: 15 }
    }
  end

  def price(goods)
    co = Checkout::Checkout.new(rules)
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

  context "Offers exist" do
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
  end

  it "calculates the right price" do
    pending("Making this pass would be a big step")
    price("").should eq 0.0
    price("A").should eq  50.0
    price("AB").should eq 80.0
    price("CDBA").should eq 115.0
    price("AA").should eq 100.0
    price("AAA").should eq 130.0
    price("AAABB").should eq 175.0
  end

end