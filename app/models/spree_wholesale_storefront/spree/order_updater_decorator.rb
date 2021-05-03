module SpreeWholesaleStorefront
  module Spree
    module OrderUpdaterDecorator

      # def update
      #   update_line_items
      #   super
      # end

      def update_order_total
        order.total = order.item_total + order.shipment_total + order.adjustment_total
        order.wholesale_total = order.wholesale_item_total + order.shipment_total + order.adjustment_total
        order.is_wholesale = order.minimum_order?
      end

      def update_item_total
        super
        order.wholesale_item_total = line_items.sum('wholesale_price * quantity')
        update_order_total
      end

      def update_adjustment_total
        recalculate_adjustments
        order.adjustment_total = line_items.sum(:adjustment_total) +
          shipments.sum(:adjustment_total) +
          adjustments.eligible.sum(:amount)
        
        if order.is_wholesale
          order.included_tax_total = line_items.sum(:wholesale_included_tax_total) + shipments.sum(:included_tax_total)
          order.additional_tax_total = line_items.sum(:wholesale_additional_tax_total) + shipments.sum(:additional_tax_total)
        else
          order.included_tax_total = line_items.sum(:included_tax_total) + shipments.sum(:included_tax_total)
          order.additional_tax_total = line_items.sum(:additional_tax_total) + shipments.sum(:additional_tax_total)
        end

        order.promo_total = line_items.sum(:promo_total) +
          shipments.sum(:promo_total) +
          adjustments.promotion.eligible.sum(:amount)
  
        update_order_total
      end

      def persist_totals
        order.update_columns(
          payment_state: order.payment_state,
          shipment_state: order.shipment_state,
          item_total: order.item_total,
          item_count: order.item_count,
          adjustment_total: order.adjustment_total,
          included_tax_total: order.included_tax_total,
          additional_tax_total: order.additional_tax_total,
          payment_total: order.payment_total,
          shipment_total: order.shipment_total,
          promo_total: order.promo_total,
          total: order.total,
          wholesale_total: order.wholesale_total,
          wholesale_item_total: order.wholesale_item_total,
          is_wholesale: order.is_wholesale,
          updated_at: Time.current
        )
      end

      # def update_line_items
      #   # order.line_items.reload
      #   if order.is_wholesale?
      #     should_update_items = line_items.should_update_to_wholesale

      #     should_update_items.each do |item|
      #       should_update = item.price != item.variant.wholesale_price
      #       if should_update
      #         item.update_price
      #         item.save!
      #         item.redo_adjustments
      #       end
      #     end
      #   else
      #     wholesale_items = line_items.should_update_to_non_wholesale
      #     wholesale_items.each do |item|
      #       should_update = item.price != item.variant.price
      #       if should_update
      #         begin
      #           item.update_price
      #           item.save!
      #           item.redo_adjustments
      #         rescue => exception
                
      #         end
      #       end
      #     end
      #   end
      #  end
    end
  end
end

Spree::OrderUpdater.prepend SpreeWholesaleStorefront::Spree::OrderUpdaterDecorator
