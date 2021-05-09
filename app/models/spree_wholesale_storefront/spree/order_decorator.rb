module SpreeWholesaleStorefront
  module Spree
    module OrderDecorator
      def self.prepended(base)
        base.preference :minimum_wholesale_order, :decimal, default: 300.0

        base.extend ::Spree::DisplayMoney
        base.money_methods :wholesale_item_total

      end

      def is_wholesale?(total_to_check = nil)
        total_to_check ||= wholesale_item_total
        return false if user.nil? || !user.wholesaler?
        total_to_check >= minimum_order_value
      end


      def minimum_order?
        return false if user.nil? || !user.wholesaler?
        wholesale_item_total >= minimum_order_value
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
