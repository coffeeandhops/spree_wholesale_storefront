module SpreeWholesaleStorefront
  module Spree
    module UsersControllerDecorator
      def self.prepended(base)
        base.before_action :load_wholesaler, except: [:index, :update]
      end

      private

      def load_wholesaler
        if @user
          @wholesaler ||= @user.wholesaler.nil? ? @user.build_wholesaler : @user.wholesaler
        end
        nil
      end

    end
  end
end

Spree::Admin::UsersController.prepend SpreeWholesaleStorefront::Spree::UsersControllerDecorator
