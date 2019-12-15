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
          self.price = order.is_wholesale? && variant.is_wholesaleable? ? variant.wholesale_price : variant.price
        end
      end

      # def update_price
      #   price_to_use = (order.is_wholesale? && variant.is_wholesaleable?) ? :wholesale_price : :price
      #   pp "PRICE TO USE"
      #   pp price_to_use
      #   self.price = variant.price_including_vat_for(tax_zone: tax_zone, use_price: price_to_use)
      # end

      def total_wholesale_price
        wholesale_price * quantity
      end
      
      def display_wholesale_price
        ::Spree::Money.new(wholesale_price, currency: currency)
      end

    end
  end
end

Spree::LineItem.prepend SpreeWholesaleStorefront::Spree::LineItemDecorator




