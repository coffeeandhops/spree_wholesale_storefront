module SpreeWholesaleStorefront
  module Spree
    module ProductDecorator
      def self.prepended(base)
        base.scope :wholesaleable, -> { joins('LEFT OUTER JOIN "spree_variants" ON "spree_variants"."product_id" = "spree_products"."id"')
            .joins('LEFT OUTER JOIN "spree_prices" ON "spree_prices"."variant_id" = "spree_variants"."id"')
            .where("spree_prices.amount NOT NULL AND spree_prices.type = 'Spree::WholesalePrice'") }

        base.delegate :wholesale_price, :is_wholesaleable?, to: :master
      end
    end
  end
end

Spree::Product.prepend SpreeWholesaleStorefront::Spree::ProductDecorator
