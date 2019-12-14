class AddWholesaler < ActiveRecord::Migration[6.0]
  def change
    create_table :spree_wholesalers do |t|
      t.references :user
      t.integer :billing_address_id
      t.integer :shipping_address_id
      t.string :company
      t.string :buyer_contact
      t.string :manager_contact
      t.string :phone
      t.string :web_address
      t.string :alternate_email
      t.text   :notes
      t.timestamps
    end
    add_index :spree_wholesalers, [:billing_address_id, :shipping_address_id], :name => "wholesalers_addresses"
  end
  # def self.up
  #   create_table :spree_wholesalers do |t|
  #     t.references :user
  #     t.integer :billing_address_id
  #     t.integer :shipping_address_id
  #     t.string :company
  #     t.string :buyer_contact
  #     t.string :manager_contact
  #     t.string :phone
  #     t.string :web_address
  #     t.string :alternate_email
  #     t.text   :notes
  #     t.timestamps
  #   end
  #   add_index :spree_wholesalers, [:billing_address_id, :shipping_address_id], :name => "wholesalers_addresses"
  # end

  # def self.down
  #   drop_table :spree_wholesalers
  # end
  
end
