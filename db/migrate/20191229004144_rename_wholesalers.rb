class RenameWholesalers < ActiveRecord::Migration[5.2]
  def change
    rename_table :wholesalers, :spree_wholesalers
  end
end
