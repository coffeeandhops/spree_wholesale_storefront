
module SpreeWholesaleStorefront
  module Spree
    module Calculator
      module TaxRateDecorator

        def compute_shipment_or_line_item(item)
          amount = item.pre_tax_amount
          discount_amount = item.discounted_amount

          if item.respond_to?(:order) && item.order.respond_to?(:is_wholesale?) && item.respond_to?(:wholesale_pre_tax_amount)
            total = item.order.line_items.sum('wholesale_price * quantity')
            if item.order.is_wholesale?(total)
              amount = item.wholesale_pre_tax_amount
              discount_amount = item.discounted_wholesale_amount
            end
          end

          if rate.included_in_price
            deduced_total_by_rate(amount, rate)
          else
            round_to_two_places(discount_amount * rate.amount)
          end
        end

        alias compute_shipment compute_shipment_or_line_item
        alias compute_line_item compute_shipment_or_line_item

      end
    end
  end
end

Spree::Calculator::DefaultTax.prepend SpreeWholesaleStorefront::Spree::Calculator::TaxRateDecorator