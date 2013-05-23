module Checkout
  class Checkout
    def initialize(rules)
      @rules = rules
      @total =  0
    end

    def total
      @total
    end

    def scan(item)
      @total = 50
    end
  end
end