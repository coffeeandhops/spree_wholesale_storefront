Deface::Override.new( :virtual_path => 'spree/admin/products/_form',
  :name => 'admin_wholesale_price_products',
  :insert_after => "[data-hook='admin_product_form_price']",
  :partial => "spree/admin/wholesalers/wholesale_price_field",
  :original => '1cf1e743e552f1fae35c0f3584123a8e3058e27d',
  :disabled => false)
