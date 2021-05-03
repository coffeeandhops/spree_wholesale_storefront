class AddWholesaleToOrder < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_orders, :wholesale_user, :boolean, default: false
    add_column :spree_orders, :is_wholesale, :boolean, default: false
    add_column :spree_orders, :wholesale_item_total, :decimal, precision: 10, scale: 2, default: "0.0", null: false
    add_column :spree_orders, :wholesale_total, :decimal, precision: 10, scale: 2, default: "0.0", null: false
  end
end
