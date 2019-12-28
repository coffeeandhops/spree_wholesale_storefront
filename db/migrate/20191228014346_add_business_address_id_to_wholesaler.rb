class AddBusinessAddressIdToWholesaler < ActiveRecord::Migration[6.0]
  def change
    add_column :spree_wholesalers, :business_address_id, :integer
  end
end
