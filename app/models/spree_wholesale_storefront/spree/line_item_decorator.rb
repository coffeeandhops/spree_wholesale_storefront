module SpreeWholesaleStorefront
  module Spree
    module LineItemDecorator
      module ClassMethods
        def wholesales
          ::Spree::LineItem.joins(variant: :wholesale_prices).where('spree_wholesale_prices.amount > ?', 0.0)
        end
        
        def non_wholesales
          ::Spree::LineItem.joins(variant: :wholesale_prices).where('spree_wholesale_prices.amount = ?', 0.0)
        end

        def should_update_to_wholesale
          ::Spree::LineItem.joins(variant: :wholesale_prices).where('spree_wholesale_prices.amount > 0.0 AND spree_wholesale_prices.amount <> price')
        end

        def should_update_to_non_wholesale
          ::Spree::LineItem.joins(variant: :wholesale_prices).where('spree_wholesale_prices.amount > 0.0 AND spree_wholesale_prices.amount = price')
        end
      end

      def self.prepended(base)
        base.delegate :wholesale_price, to: :variant

        class << base
          prepend ClassMethods
        end

      end

      # def price
      #   is_wholesaleable? ? wholesale_price : self[:price]
      # end

      def update_price
        if is_wholesaleable?
          self.price = variant.wholesale_price_including_vat_for(tax_zone: tax_zone)
        else
          self.price = variant.price_including_vat_for(tax_zone: tax_zone)
        end
      end

      def total_wholesale_price
        return 0.0 if variant.nil? || wholesale_price.nil? || quantity.nil?
        wholesale_price * quantity
      end
      
      def display_wholesale_price
        ::Spree::Money.new(wholesale_price, currency: currency)
      end

      def display_total_wholesale_price
        ::Spree::Money.new(total_wholesale_price, currency: currency)
      end

      def is_wholesaleable?
        false if order.nil? || variant.nil?
        variant.is_wholesaleable? && order.is_wholesale?
      end

      def redo_adjustments
        recalculate_adjustments
        update_tax_charge # Called to ensure pre_tax_amount is updated.
      end

    end
  end
end

Spree::LineItem.prepend SpreeWholesaleStorefront::Spree::LineItemDecorator
