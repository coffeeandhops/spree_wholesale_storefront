class RemoveCompanyFromWholesalers < ActiveRecord::Migration[6.0]
  def change
    remove_column :spree_wholesalers, :company, :string
    remove_column :spree_wholesalers, :phone, :string
  end
end
