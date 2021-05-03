module SpreeWholesaleStorefront
  module Spree
    module CartSerializerDecorator
      def self.prepended(base)
        base.attributes :is_wholesale, :wholesale_item_total
        base.attribute :display_wholesale_item_total, &:display_wholesale_item_total
      end
    end
  end
end

Spree::V2::Storefront::CartSerializer.prepend SpreeWholesaleStorefront::Spree::CartSerializerDecorator