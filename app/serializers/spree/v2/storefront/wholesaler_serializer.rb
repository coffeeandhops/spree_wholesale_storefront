module Spree
  module V2
    module Storefront
      class WholesalerSerializer < BaseSerializer
        set_type :wholesaler

        attributes :email, :company, :buyer_contact, :manager_contact, :phone, :web_address,
        :alternate_email, :notes, :bio, :display_name, :user_id
    
        belongs_to :user
      end
    end
  end
end
