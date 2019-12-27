class AddDisplayNameToSpreeWholesalers < ActiveRecord::Migration[6.0]
  def change
    add_column :spree_wholesalers, :display_name, :text
  end
end
