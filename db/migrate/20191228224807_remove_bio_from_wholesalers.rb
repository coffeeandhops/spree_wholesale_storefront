class RemoveBioFromWholesalers < ActiveRecord::Migration[6.0]
  def change
    remove_column :spree_wholesalers, :bio, :text
    remove_column :spree_wholesalers, :display_name, :text
    rename_column :spree_wholesalers, :buyer_contact, :main_contact
    rename_column :spree_wholesalers, :manager_contact, :alternate_contact
  end
end
