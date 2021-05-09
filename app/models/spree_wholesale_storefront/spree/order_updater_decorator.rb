module SpreeWholesaleStorefront
  module Spree
    module OrderUpdaterDecorator
      def self.prepended(base)
        base.attr_accessor :wholesale_change, :current_wholesale_status
      end

      # def update
      #   update_line_items
      #   super
      # end

      def update_order_total
        order.wholesale_total = order.wholesale_item_total + order.shipment_total + order.adjustment_total
        order.is_wholesale = order.is_wholesale?(order.wholesale_total)
        @wholesale_change = @current_wholesale_status != order.is_wholesale
        if order.is_wholesale
          order.total = order.wholesale_total
        else
          order.total = order.item_total + order.shipment_total + order.adjustment_total
        end
      end

      def update_item_total
        @current_wholesale_status = order.is_wholesale
        super
        order.wholesale_item_total = line_items.sum('wholesale_price * quantity')
        update_order_total
      end

      def update_adjustment_total
        pp "###############################"
        pp "recalculate_adjustments START"
        pp "###############################"
        non_item_adjustments = order.all_adjustments.where.not(adjustable_type: 'Spree::LineItem')
        recalculate_adjustments if non_item_adjustments.any? || wholesale_change
        pp "###############################"
        pp "recalculate_adjustments FINISH"
        pp "###############################"
        order.adjustment_total = line_items.sum(:adjustment_total) +
          shipments.sum(:adjustment_total) +
          adjustments.eligible.sum(:amount)
        
        # if order.is_wholesale
        #   order.included_tax_total = line_items.sum(:wholesale_included_tax_total) + shipments.sum(:included_tax_total)
        #   order.additional_tax_total = line_items.sum(:wholesale_additional_tax_total) + shipments.sum(:additional_tax_total)
        # else
        #   order.included_tax_total = line_items.sum(:included_tax_total) + shipments.sum(:included_tax_total)
        #   order.additional_tax_total = line_items.sum(:additional_tax_total) + shipments.sum(:additional_tax_total)
        # end
        order.included_tax_total = line_items.sum(:included_tax_total) + shipments.sum(:included_tax_total)
        order.additional_tax_total = line_items.sum(:additional_tax_total) + shipments.sum(:additional_tax_total)

        order.promo_total = line_items.sum(:promo_total) +
          shipments.sum(:promo_total) +
          adjustments.promotion.eligible.sum(:amount)
        
        pp "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
        pp "update_order_total in update_adjustment_total START"
        pp "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
        update_order_total
        pp "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
        pp "update_order_total in update_adjustment_total FINISH"
        pp "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
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
