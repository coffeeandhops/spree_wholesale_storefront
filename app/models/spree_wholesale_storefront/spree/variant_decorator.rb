module SpreeWholesaleStorefront
  module Spree
    module VariantDecorator
      module ClassMethods
        def wholesales
          ::Spree::Variant.all.select { |v| !v.wholesale_price.nil? }
        end
      end

      def self.prepended(base)
        base.has_many :wholesale_prices,
          class_name: '::Spree::WholesalePrice',
          dependent: :destroy,
          inverse_of: :variant

        base.include ::Spree::DefaultWholesalePrice

        class << base
          prepend ClassMethods
        end
      end

      def price_in(currency)
        prices.detect { |price| price.currency == currency && price.type != "Spree::WholesalePrice" } || prices.build(currency: currency)
      end

      def wholesale_price_in(currency)
        return wholesale_prices.detect { |price| price.currency == currency && price.type == "Spree::WholesalePrice" } || wholesale_prices.build(currency: currency)
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
