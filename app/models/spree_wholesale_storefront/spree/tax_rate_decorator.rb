module SpreeWholesaleStorefront
  module Spree
    module TaxRateDecorator
      module ClassMethods
         # Pre-tax amounts must be stored so that we can calculate
        # correct rate amounts in the future. For example:
        # https://github.com/spree/spree/issues/4318#issuecomment-34723428
        def store_pre_tax_amount(item, rates)
          pre_tax_amount = case item.class.to_s
                          when 'Spree::LineItem' then item.discounted_amount
                          when 'Spree::Shipment' then item.discounted_cost
                          end

          included_rates = rates.select(&:included_in_price)
          if included_rates.any?
            pre_tax_amount /= (1 + included_rates.sum(&:amount))
          end

          item.update_column(:pre_tax_amount, pre_tax_amount)

          if (item.class.to_s == 'Spree::LineItem')
            pp "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
            pp "store_pre_tax_amount #{item.id}"
            wholesale_pre_tax_amount = item.discounted_wholesale_amount
            if included_rates.any?
              wholesale_pre_tax_amount /= (1 + included_rates.sum(&:amount))
            end
            item.update_column(:wholesale_pre_tax_amount, wholesale_pre_tax_amount)
          end
        end
      end

      def self.prepended(base)
        class << base
          prepend ClassMethods
        end
      end
    end
  end
end

Spree::TaxRate.prepend SpreeWholesaleStorefront::Spree::TaxRateDecorator
