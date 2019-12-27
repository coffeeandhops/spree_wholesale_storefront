Deface::Override.new( :virtual_path => 'spree/admin/products/_form',
  :name => 'admin_wholesale_price_products',
  :insert_after => "[data-hook='admin_product_form_price']",
  :partial => "spree/admin/wholesalers/wholesale_price_field",
  :disabled => false)
