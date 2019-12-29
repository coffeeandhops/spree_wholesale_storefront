class AddTypeToSpreePrices < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_prices, :type, :string
  end
end
