Deface::Override.new(virtual_path: "spree/admin/shared/sub_menu/_configuration",
                    name: 'admin-configuration',
                    insert_bottom: "[data-hook='admin_configurations_sidebar_menu']",
                    text: "<%= configurations_sidebar_menu_item(t('wholesale'),
                     edit_admin_wholesale_configurations_path) %>"
                    )
