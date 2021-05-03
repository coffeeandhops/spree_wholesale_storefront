module SpreeWholesaleStorefront
  module Spree
    module OrderDecorator
      def self.prepended(base)
        base.preference :minimum_wholesale_order, :decimal, default: 300.0

        base.extend ::Spree::DisplayMoney
        base.money_methods :wholesale_item_total

      end

      def is_wholesale?
        is_wholesale
        # !user.nil? && user.wholesaler? && minimum_order
      end

      # def wholesale_item_total
      #   line_items.reload
      #   line_items.sum(&:total_wholesale_price)
      # end

      def minimum_order?
        # minimum = ::Spree::WholesaleStorefront::Config[:minimum_order]
        return false if user.nil? || !user.wholesaler?
        minimum = minimum_order_value
        wholesale_item_total >= minimum
      end

      private
      attr_accessor :config_minimum_order_value

      def minimum_order_value
        @config_minimum_order_value ||= ::Spree::WholesaleStorefront::Config[:minimum_order]
      end

    end
  end
end

Spree::Order.prepend SpreeWholesaleStorefront::Spree::OrderDecorator
