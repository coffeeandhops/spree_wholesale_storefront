class AddLatLongToSpreeAddresses < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_addresses, :latitude, :float
    add_column :spree_addresses, :longitude, :float
  end
end
