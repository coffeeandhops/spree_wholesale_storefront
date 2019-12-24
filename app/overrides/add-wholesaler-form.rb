Deface::Override.new(
  virtual_path: 'spree/admin/users/edit',
  name: 'wholesaler_user_form',
  insert_after: '[data-hook="admin_user_edit_general_settings"]',
  text: '<%= render  "spree/admin/users/wholesalers/form" %>'
)
