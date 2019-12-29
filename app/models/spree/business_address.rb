module Spree
  class BusinessAddress < ::Spree::Address
    has_one :wholesaler

    alias_attribute :business_name, :company
    alias_attribute :first_name, :company
    alias_attribute :last_name, :company
    alias_attribute :firstname, :company
    alias_attribute :lastname, :company

    with_options presence: true do
      validates :address1, :city, :country, :company
      validates :zipcode, if: :require_zipcode?
      validates :phone, if: :require_phone?
    end
  end
end
