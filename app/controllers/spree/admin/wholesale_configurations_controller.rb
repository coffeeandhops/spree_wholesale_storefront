module Spree
  module Admin
    class WholesaleConfigurationsController < ResourceController

      def update
        config = Spree::WholesaleConfiguration.new
        @preferences = params && params.key?(:preferences) ? params.delete(:preferences) : params
        @preferences.each do |name, value|
          next unless config.has_preference? name
          config[name] = value
        end
        flash[:success] = Spree.t(:successfully_updated, resource: Spree.t(:wholesale_configuration, scope: :spree_wholesale_storefront))
        redirect_to edit_admin_wholesale_configurations_path
      end
    end
  end
end
