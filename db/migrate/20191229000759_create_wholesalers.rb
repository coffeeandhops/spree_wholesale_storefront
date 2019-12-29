class CreateWholesalers < ActiveRecord::Migration[5.2]
  def change
    create_table :wholesalers do |t|
      t.references :user
      t.string :main_contact
      t.string :alternate_contact
      t.string :web_address
      t.string :alternate_email
      t.text   :notes
      t.integer :business_address_id
      t.timestamps
    end
  end
end
