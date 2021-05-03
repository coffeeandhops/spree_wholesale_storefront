module SpreeWholesaleStorefront
  module Spree
    module VariantDecorator
      module ClassMethods
        def wholesales
          # ::Spree::Variant.all.select { |v| !v.wholesale_price.nil? }
          ::Spree::Variant.joins(:wholesale_prices).where('spree_wholesale_prices.amount > ?', 0.0)
        end
      end

      def self.prepended(base)
        
        base.include ::Spree::DefaultWholesalePrice

        base.has_many :wholesale_prices,
          class_name: 'Spree::WholesalePrice',
          dependent: :destroy,
          inverse_of: :variant

        class << base
          prepend ClassMethods
        end
      end

      def wholesale_price_in(currency)
        wholesale_prices.detect { |price| price.currency == currency } || wholesale_prices.build(currency: currency)
      end

      def wholesale_amount_in(currency)
        wholesale_price_in(currency).try(:amount)
      end

      def is_wholesaleable?
        wholesale_price.present? && wholesale_price > 0
      end
    end
  end
end

Spree::Variant.prepend SpreeWholesaleStorefront::Spree::VariantDecorator
