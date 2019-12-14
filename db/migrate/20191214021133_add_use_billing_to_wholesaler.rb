class AddUseBillingToWholesaler < ActiveRecord::Migration[6.0]
  def change
    add_column :spree_wholesalers, :use_billing, :boolean, default: true
  end
end
