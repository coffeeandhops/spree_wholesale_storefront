class AddBioToSpreeWholesalers < ActiveRecord::Migration[6.0]
  def change
    add_column :spree_wholesalers, :bio, :text
  end
end
