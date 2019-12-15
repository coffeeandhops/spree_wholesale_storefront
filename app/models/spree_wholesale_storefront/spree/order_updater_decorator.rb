module SpreeWholesaleStorefront
  module Spree
    module OrderUpdaterDecorator

      # TODO: Look into whether this needs to update for the wholesale_price total
      def update_item_total
        order.item_total = line_items.sum('price * quantity')
        update_order_total
      end

    end
  end
end

Spree::OrderUpdater.prepend SpreeWholesaleStorefront::Spree::OrderUpdaterDecorator

