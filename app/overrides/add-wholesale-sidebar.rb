Deface::Override.new(
  virtual_path: 'spree/admin/users/_sidebar',
  name: 'wholesaler_sidebar_item',
  insert_bottom: '[data-hook="admin_user_tab_options"]',
  partial: "spree/admin/users/wholesalers/sidebar"
)
