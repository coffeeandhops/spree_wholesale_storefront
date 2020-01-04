module SpreeWholesaleStorefront
  module Spree
    module UsersControllerDecorator
      def self.prepended(base)
        base.before_action :load_wholesaler
      end

      def wholesalers
        return @collection if @collection.present?

        @collection = ::Spree.user_class.where(nil)
        @search = @collection.ransack(params[:q])
        @users = @search.result.wholesale.page(params[:page]).per(::Spree::Config[:admin_users_per_page])
        # render spree.admin_users_path
        render :index
      end

      private

      def load_wholesaler
        if @user
          @wholesaler ||= @user.wholesaler.nil? ? @user.build_wholesaler : @user.wholesaler
        end
        nil
      end

      def serialize_collection(collection)
        collection_serializer.new(
          collection,
          collection_options(collection)
        ).serializable_hash
      end
      
    end
  end
end

Spree::Admin::UsersController.prepend SpreeWholesaleStorefront::Spree::UsersControllerDecorator
