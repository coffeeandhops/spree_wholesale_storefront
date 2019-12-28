module SpreeWholesaleStorefront
  module Spree
    module LineItemSerializerDecorator
      def self.prepended(base)
        base.attribute :total_wholesale_price, &:total_wholesale_price
        base.attribute :display_wholesale_price, &:display_wholesale_price
        base.attribute :is_wholesaleable, &:is_wholesaleable?
      end
    end
  end
end

Spree::V2::Storefront::LineItemSerializer.prepend SpreeWholesaleStorefront::Spree::LineItemSerializerDecorator