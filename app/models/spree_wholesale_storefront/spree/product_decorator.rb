module SpreeWholesaleStorefront
  module Spree
    module ProductDecorator
      def self.prepended(base)

        base.delegate :wholesale_price, :wholesale_price=, :is_wholesaleable?,
                      :display_wholesale_price, :display_wholesale_amount, to: :find_or_build_master

        base.has_many :wholesale_prices, -> { order('spree_variants.position, spree_variants.id, currency') }, through: :variants

        base.scope :wholesaleable, -> { joins('LEFT OUTER JOIN "spree_variants" ON "spree_variants"."product_id" = "spree_products"."id"')
          .joins('LEFT OUTER JOIN "spree_wholesale_prices" ON "spree_wholesale_prices"."variant_id" = "spree_variants"."id"')
          .where("spree_wholesale_prices.amount NOT NULL") }

        # [:is_wholesaleable?, :wholesale_price, :wholesale_price_in, :wholesale_amount_in].each do |method_name|
        #   delegate method_name, :"#{method_name}=", to: :find_or_build_master
        # end
    
        # delegate :display_wholesale_amount, :display_wholesale_price,
        #   :has_default_wholesale_price?, to: :find_or_build_master          
      end

      def master_updated?
        super ||
        (
          master.default_wholesale_price &&
          (
            master.default_wholesale_price.new_record? ||
            master.default_wholesale_price.changed?
          )
        )
      end

    end
  end
end

Spree::Product.prepend SpreeWholesaleStorefront::Spree::ProductDecorator
