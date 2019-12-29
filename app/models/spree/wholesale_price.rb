module Spree
  class WholesalePrice < ::Spree::Price
    alias_attribute :wholesale_price, :amount
    
    extend DisplayMoney
    money_methods :wholesale_price
  
  end
end
