Deface::Override.new( :virtual_path => 'spree/admin/variants/_form',
  :name => 'admin_wholesale_price_variants',
  :insert_after => "[data-hook='price']",
  :partial => "spree/admin/variants/wholesale_price_field",
  :disabled => false)
