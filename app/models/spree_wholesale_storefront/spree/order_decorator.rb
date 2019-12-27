module SpreeWholesaleStorefront
  module Spree
    module OrderDecorator
      def self.prepended(base)
        base.preference :minimum_wholesale_order, :decimal, default: 300.0

        base.extend ::Spree::DisplayMoney
        base.money_methods :wholesale_item_total

      end

      def is_wholesale?
        !user.nil? && user.wholesaler? && minimum_order
      end

      def wholesale_item_total
        line_items.sum(&:total_wholesale_price)
      end

      private

      def minimum_order
        minimum = ::Spree::WholesaleStorefront::Config[:minimum_order]
        wholesale_item_total >= minimum
      end
    end
  end
end

Spree::Order.prepend SpreeWholesaleStorefront::Spree::OrderDecorator
