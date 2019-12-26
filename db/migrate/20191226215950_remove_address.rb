class RemoveAddress < ActiveRecord::Migration[6.0]
  def change
    remove_column :spree_wholesalers, :billing_address_id, :integer
    remove_column :spree_wholesalers, :shipping_address_id, :integer
    remove_column :spree_wholesalers, :use_billing, :boolean
  end
end
