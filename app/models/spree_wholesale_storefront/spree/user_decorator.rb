module SpreeWholesaleStorefront
  module Spree
    module UserDecorator
      def self.prepended(base)
        base.has_one :wholesaler, class_name: "Spree::Wholesaler"
        base.scope :wholesale, lambda { includes(:spree_roles).where("spree_roles.name" => "wholesaler") }
      end

      def wholesaler?
        has_spree_role?("wholesaler") && !wholesaler.nil?
      end

    end
  end
end

Spree.user_class.prepend SpreeWholesaleStorefront::Spree::UserDecorator
