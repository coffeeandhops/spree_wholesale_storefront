module Spree
  class WholesaleConfiguration < Preferences::Configuration
    preference :minimum_order, :decimal, default: 300.0
  end
end
