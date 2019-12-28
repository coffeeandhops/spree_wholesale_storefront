module Spree
  module Admin
    class WholesalersController < ResourceController


      def create
        @wholesaler = Spree::Wholesaler.new(wholesaler_params)
        if @wholesaler.save
          flash[:notice] = I18n.t('spree.spree_wholesale_storefront.success')
          redirect_to spree.edit_admin_user_path(id: @wholesaler.user_id)
        else
          flash[:error] = I18n.t('spree.spree_wholesale_storefront.failed')
          flash[:error] = @wholesaler.errors.full_messages.to_sentence
          redirect_to spree.edit_admin_user_path(id: @wholesaler.user_id)
        end
      end

      def update
        @wholesaler = Spree::Wholesaler.find(params[:id])
        if @wholesaler.update_attributes(wholesaler_params)
          flash[:notice] = I18n.t('spree.spree_wholesale_storefront.update_success')
        else
          flash[:error] = I18n.t('spree.spree_wholesale_storefront.update_failed')
          flash[:error] = @wholesaler.errors.full_messages.to_sentence
        end
        redirect_to spree.edit_admin_user_path(id: @wholesaler.user_id)
      end

      def destroy
        @wholesaler = Spree::Wholesaler.find(params[:id])
        @wholesaler.destroy
        flash[:notice] = I18n.t('spree.spree_wholesale_storefront.destroy_success')
        redirect_to spree.edit_admin_user_path(id: @wholesaler.user_id)
      end

      private

      def collection
        return @collection if @collection.present?

        @collection = ::Spree.user_class.where(nil)
        @search = @collection.ransack(params[:q])
        @collection = @search.result.wholesale.page(params[:page]).per(::Spree::Config[:admin_users_per_page])
      end

      def wholesaler_params
        params.require(:wholesaler).permit([
          :company, :buyer_contact, :manager_contact, :web_address, :phone, :notes,:user_id, :alternate_email,
          :business_address_attributes => [
            :address1, :address2, :city, :zipcode, :phone, :state_name, :alternative_phone, :company, :state_id, :country_id
          ]
        ])
      end      
    end
  end
end

