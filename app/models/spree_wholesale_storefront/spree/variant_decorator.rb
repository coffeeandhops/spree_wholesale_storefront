module SpreeWholesaleStorefront
  module Spree
    module VariantDecorator
      module ClassMethods
        def wholesales
          ::Spree::Variant.all.select { |v| !v.wholesale_price.nil? }
        end
      end

      def self.prepended(base)
        base.has_many :prices,
          lambda {
            where(type: 'Spree::Price')
          },
          class_name: '::Spree::Price',
          dependent: :destroy,
          inverse_of: :variant

        base.has_many :wholesale_prices,
          class_name: '::Spree::WholesalePrice',
          dependent: :destroy,
          inverse_of: :variant

        base.include ::Spree::DefaultWholesalePrice

        class << base
          prepend ClassMethods
        end
      end

      def wholesale_price_in(currency)
        return wholesale_prices.detect { |price| price.currency == currency } || wholesale_prices.build(currency: currency)
      end 
      
      def wholesale_amount_in(currency)
        wholesale_price_in(currency).try(:amount)
      end

      def is_wholesaleable?
        wholesale_price.present?
      end

    end
  end
end

Spree::Variant.prepend SpreeWholesaleStorefront::Spree::VariantDecorator
