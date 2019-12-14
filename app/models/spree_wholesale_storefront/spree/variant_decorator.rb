module SpreeWholesaleStorefront
  module Spree
    module VariantDecorator
      
      def self.prepended(base)
        base.scope :wholesales, ->{where("spree_variants.wholesale_price NOT NULL")}
      end

      def price_in(currency)
        return super(currency) unless wholesale_price.present?
        ::Spree::Price.new(variant_id: self.id, amount: self.wholesale_price, currency: currency)
      end

      def is_wholesaleable?
        wholesale_price.present?
      end

    end
  end
end

Spree::Variant.prepend SpreeWholesaleStorefront::Spree::VariantDecorator
