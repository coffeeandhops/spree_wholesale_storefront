module SpreeWholesaleStorefront
  module Spree
    module LineItemDecorator

      def self.prepended(base)
        base.delegate :wholesale_price, to: :variant
      end

      def update_price
        return self.price = variant.price_including_vat_for(tax_zone: tax_zone) unless is_wholesaleable?
        self.price = variant.wholesale_price_including_vat_for(tax_zone: tax_zone)
      end

      def total_wholesale_price
        wholesale_price * quantity
      end
      
      def display_wholesale_price
        ::Spree::Money.new(wholesale_price, currency: currency)
      end

      def is_wholesaleable?
        false if order.nil? || variant.nil?
        variant.is_wholesaleable? && order.is_wholesale?
      end

    end
  end
end

Spree::LineItem.prepend SpreeWholesaleStorefront::Spree::LineItemDecorator
