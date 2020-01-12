Deface::Override.new(virtual_path: "spree/admin/shared/_main_menu",
  name: 'wholesalers-tab',
  insert_bottom: "nav",
  text: "<%= render 'spree/admin/wholesalers/tab' %>")