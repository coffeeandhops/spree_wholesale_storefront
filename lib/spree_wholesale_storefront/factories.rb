FactoryBot.define do
  # Define your Spree extensions Factories within this file to enable applications, and other extensions to use and override them.
  #
  # Example adding this to your spec_helper will load these Factories for use:
  # require 'spree_wholesale_storefront/factories'
  require_relative '../../spec/factories/business_address_factory'
  require_relative '../../spec/factories/wholesale_line_item_factory'
  require_relative '../../spec/factories/wholesale_order_factory'
  require_relative '../../spec/factories/wholesale_price_factory'
  require_relative '../../spec/factories/wholesale_user_factory'
  require_relative '../../spec/factories/wholesale_variant_factory'
  require_relative '../../spec/factories/wholesaler_factory'

end
