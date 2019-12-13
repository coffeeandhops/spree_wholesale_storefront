module SpreeWholesaleStorefront
  module Spree
    module ProductDecorator
      def self.prepended(base)
        base.scope :wholesaleable, -> { joins('LEFT OUTER JOIN "spree_variants" ON "spree_variants"."product_id" = "spree_products"."id"')
            .where("spree_variants.wholesale_price NOT NULL AND spree_variants.wholesale_price > 0.0") }
            
        base.delegate :wholesale_price, to: :master if ::Spree::Variant.table_exists? && ::Spree::Variant.column_names.include?("wholesale_price")
      end

      def is_wholesaleable?
        master.wholesale_price.present?
      end

    end
  end
end

Spree::Product.prepend SpreeWholesaleStorefront::Spree::ProductDecorator
