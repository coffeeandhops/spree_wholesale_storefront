module Spree
  class Wholesaler < ActiveRecord::Base
    belongs_to :user, class_name: Spree.user_class.to_s

    validates :company, :buyer_contact, :phone, presence: true
    
    delegate :email, to: :user
  end
end

