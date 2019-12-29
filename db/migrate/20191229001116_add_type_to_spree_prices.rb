class AddTypeToSpreePrices < ActiveRecord::Migration[6.0]
  def change
    add_column :spree_prices, :type, :string
  end
end
