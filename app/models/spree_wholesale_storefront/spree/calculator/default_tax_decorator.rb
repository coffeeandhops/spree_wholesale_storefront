
module SpreeWholesaleStorefront
  module Spree
    module Calculator
      module TaxRateDecorator

        def compute_shipment_or_line_item(item)
          amount = item.pre_tax_amount
          discount_amount = item.discounted_amount
          if item.respond_to?(:order) && item.order.respond_to?(:is_wholesale) && item.order.is_wholesale
            amount = item.wholesale_pre_tax_amount
            discount_amount = item.discounted_wholesale_amount
            pp "()()()()()()()()()()()()()()()()()()()()()()()()()()"
            pp "()()()()()()()()()()()()()()()()()()()()()()()()()()"
            pp "()()()()()()()()()()()()()()()()()()()()()()()()()()"
            pp "In the right tax calculator"
            pp amount
            pp discount_amount
            pp "()()()()()()()()()()()()()()()()()()()()()()()()()()"
            pp "()()()()()()()()()()()()()()()()()()()()()()()()()()"
            pp "()()()()()()()()()()()()()()()()()()()()()()()()()()"
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