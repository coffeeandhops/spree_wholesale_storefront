class RemoveTypeFromSpreePrice < ActiveRecord::Migration[6.0]
  def change
    remove_column :spree_prices, :type
  end
end
