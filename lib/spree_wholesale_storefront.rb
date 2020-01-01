require 'spree_core'
require 'spree_extension'
require 'spree_wholesale_storefront/engine'
require 'spree_wholesale_storefront/version'
require 'geocoder'
module Spree
  module WholesaleStorefront
    module_function

    def config(*)
      yield(Spree::WholesaleStorefront::Config)
    end
  end
end
