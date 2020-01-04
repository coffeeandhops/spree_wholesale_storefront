module SpreeWholesaleStorefront
  module Spree
    module LineItemSerializerDecorator
      def self.prepended(base)
        base.attribute :total_wholesale_price, &:total_wholesale_price
        base.attribute :display_wholesale_price, &:display_wholesale_price
        base.attribute :is_wholesaleable, &:is_wholesaleable?
        base.attribute :display_total_wholesale_price, &:display_total_wholesale_price
      end
    end
  end
end

Spree::V2::Storefront::LineItemSerializer.prepend SpreeWholesaleStorefront::Spree::LineItemSerializerDecorator