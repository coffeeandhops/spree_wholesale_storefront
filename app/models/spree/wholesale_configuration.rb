module Spree
  class WholesaleConfiguration < Preferences::Configuration
    preference :minimum_order, :decimal, default: 300.0
    preference :google_map_api_key, :string, default: ''
  end
end