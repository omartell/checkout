require 'spec_helper'

describe Checkout::Checkout do

  # Item  Price   Offer
  # --------------------------
  # A     50       3 for 130
  # B     30       2 for 45
  # C     20
  # D     15

  def price(goods)
    co = Checkout::Checkout.new(rules)
    goods.split(//).each { |item| co.scan(item) }
    co.total
  end

  let(:rules) do

  end

  it "calculates the right price" do
    price("").should eq 0.0
    price("A").should eq  50.0
    price("AB").should eq 80.0
    price("CDBA").should eq 115.0
    price("AA").should eq 100.0
    price("AAA").should eq 130.0
    price("AAABB").should eq 175.0
  end

end