module SpreeWholesaleStorefront
  module Spree
    module OrderUpdaterDecorator

      # TODO: Look into whether this needs to update for the wholesale_price total
      def update_item_total
        return super unless order.is_wholesale?
        order.item_total = order.wholesale_item_total
        update_order_total
      end

    end
  end
end

Spree::OrderUpdater.prepend SpreeWholesaleStorefront::Spree::OrderUpdaterDecorator

