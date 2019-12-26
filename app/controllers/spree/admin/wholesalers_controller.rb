module Spree
  module Admin
    class WholesalersController < ResourceController

      before_action :approval_setup, :only => [ :approve, :reject ]

      def index
        # @collection if @collection.present?

        @collection = ::Spree.user_class.where(nil)
        @search = @collection.ransack(params[:q])
        @wholesalers = @search.result.wholesale.page(params[:page]).per(::Spree::Config[:admin_users_per_page])
      end

      def create
        @wholesaler = Spree::Wholesaler.new(wholesaler_params)
        if @wholesaler.save
          # flash[:notice] = I18n.t('spree.admin.wholesaler.success')
          flash[:notice] = 'Wholesaler account created'
          redirect_to spree.edit_admin_user_path(id: @wholesaler.user_id)
        else
          flash[:error] = @wholesaler.full_messages.to_sentence
          render spree.edit_admin_user_path(id: @wholesaler.user_id)
          # render :action => "new"
        end
      end

      def update
        @wholesaler = Spree::Wholesaler.find(params[:id])
        if @wholesaler.update_attributes(wholesaler_params)
          # flash[:notice] = I18n.t('spree.admin.wholesaler.update_success')
          flash[:notice] = 'Wholesaler account updated'
        else
          # flash[:error] = I18n.t('spree.admin.wholesaler.update_failed')
          flash[:error] = @wholesaler.errors.full_messages.to_sentence
        end
        redirect_to spree.edit_admin_user_path(id: @wholesaler.user_id)
      end

      def destroy
        @wholesaler = Spree::Wholesaler.find(params[:id])
        @wholesaler.destroy
        flash[:notice] = I18n.t('spree.admin.wholesaler.destroy_success')
        redirect_to spree.edit_admin_user_path(id: @wholesaler.user_id)
        respond_with(@wholesaler)
      end

      def approve
        return redirect_to request.referer, :flash => { :error => "Wholesaler is already active." } if @wholesaler.active?
        @wholesaler.activate!
        redirect_to request.referer, :flash => { :notice => "Wholesaler was successfully approved." }
      end

      def reject
        return redirect_to request.referer, :flash => { :error => "Wholesaler is already rejected." } unless @wholesaler.active?
        @wholesaler.deactivate!
        redirect_to request.referer, :flash => { :notice => "Wholesaler was successfully rejected." }
      end

      private

      def approval_setup
        @wholesaler = Spree::Wholesaler.find(params[:id])
        @role = Spree::Role.find_or_create_by_name("wholesaler")
      end

      def collection
        return @collection if @collection.present?

        params[:search] ||= {}
        params[:search][:meta_sort] ||= "company.asc"
        @search = Spree::Wholesaler.ransack(params[:q])
        @collection = @search.result.page(params[:page]).per(Spree::Config[:admin_products_per_page])
      end

      def wholesaler_params
        params.require(:wholesaler).permit([:company, :buyer_contact, :manager_contact, :web_address, :phone, :notes, :user_id])
      end      
    end
  end
end
