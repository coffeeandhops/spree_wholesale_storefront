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
        # base.delegate :wholesale_price, to: :variant
        
        class << base
          prepend ClassMethods
        end
        base.extend ::Spree::DisplayMoney

        base.money_methods :wholesale_amount, :total_wholesale_price, :final_wholesale_amount, :wholesale_total, :wholesale_price,
                           :wholesale_adjustment_total, :wholesale_additional_tax_total, :wholesale_promo_total, :wholesale_included_tax_total,
                          :wholesale_pre_tax_amount
  
        # base.alias single_wholesale_money display_wholesale_price
        # base.alias single_display_wholesale_amount display_wholesale_price
      end

      def copy_price
        if variant
          update_price if price.nil? || wholesale_price.nil? || wholesale_price != variant.wholesale_price
          self.cost_price = variant.cost_price if cost_price.nil?
          self.currency = variant.currency if currency.nil?
        end
      end

      def update_price
        pp "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
        pp "update price for line_item #{id}"
        pp "price.nil? = #{price.nil?}"
        pp " wholesale_price.nil? = #{ wholesale_price.nil?}"
        pp "wholesale_price != variant.wholesale_price = #{wholesale_price != variant.wholesale_price}"
        pp "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
        self.price = variant.price_including_vat_for(tax_zone: tax_zone)
        self.wholesale_price = variant.wholesale_price_including_vat_for(tax_zone: tax_zone)
      end

      def total_wholesale_price
        return 0.0 if variant.nil? || wholesale_price.nil? || quantity.nil?
        wholesale_price * quantity
      end
      
      # def display_wholesale_price
      #   ::Spree::Money.new(wholesale_price, currency: currency)
      # end

      # def display_total_wholesale_price
      #   ::Spree::Money.new(total_wholesale_price, currency: currency)
      # end

      def is_wholesaleable?
        false if order.nil? || variant.nil?
        variant.is_wholesaleable? && order.is_wholesale?
      end

      def redo_adjustments
        recalculate_adjustments
        update_tax_charge # Called to ensure pre_tax_amount is updated.
      end

      def wholesale_amount
        (wholesale_price || 0.0) * quantity
      end
  
      alias wholesale_subtotal wholesale_amount
  
      def wholesale_taxable_amount
        wholesale_amount + taxable_adjustment_total
      end
  
      alias discounted_wholesale_amount wholesale_taxable_amount
  
      def final_wholesale_amount
        wholesale_amount + adjustment_total
      end

    end
  end
end

Spree::LineItem.prepend SpreeWholesaleStorefront::Spree::LineItemDecorator
