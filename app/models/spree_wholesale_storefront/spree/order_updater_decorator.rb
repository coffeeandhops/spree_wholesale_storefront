module SpreeWholesaleStorefront
  module Spree
    module OrderUpdaterDecorator

      def update
        update_line_items
        super
      end

      def update_item_total
        return super unless order.is_wholesale?
        order.item_total = order.wholesale_item_total
        update_order_total
      end

      def update_line_items
        order.line_items.reload
        order.line_items.each do |item|
          should_update = (order.is_wholesale? && item.price != item.variant.wholesale_price) || (!order.is_wholesale? && item.price == item.variant.wholesale_price)
          if should_update
            item.update_price
            item.save!
            item.redo_adjustments
          end
        end
      end
    end
  end
end

Spree::OrderUpdater.prepend SpreeWholesaleStorefront::Spree::OrderUpdaterDecorator

