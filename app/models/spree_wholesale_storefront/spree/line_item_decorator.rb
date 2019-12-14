module SpreeWholesaleStorefront
  module Spree
    module LineItemDecorator

      def self.prepended(base)
        base.delegate :wholesale_price, to: :variant
        base.delegate :is_wholesaleable?, to: :variant
      end
      
      def copy_price
        super
        if variant
          # TODO: CHECK IF ORDER IS WHOLESALEABLE
          self.price = (variant.is_wholesaleable? ? variant.wholesale_price : variant.price)
        end
      end

    end
  end
end

Spree::LineItem.prepend SpreeWholesaleStorefront::Spree::LineItemDecorator




