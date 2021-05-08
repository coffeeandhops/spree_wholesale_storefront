
module SpreeWholesaleStorefront
  module Spree
    module Calculator
      module TaxRateDecorator

        def compute_shipment_or_line_item(item)
          amount = item.pre_tax_amount
          discount_amount = item.discounted_amount
          if item.respond_to?(:order) && i.order.respond_to?(:is_wholesale) && i.order.is_wholesale
            amount = item.i.wholesale_pre_tax_amount
            discount_amount = item.i.discounted_wholesale_amount
           end
          if rate.included_in_price
            deduced_total_by_rate(amount, rate)
          else
            round_to_two_places(discount_amount * rate.amount)
          end
        end

      end
    end
  end
end

Spree::Calculator::DefaultTax.prepend SpreeWholesaleStorefront::Spree::Calculator::TaxRateDecorator