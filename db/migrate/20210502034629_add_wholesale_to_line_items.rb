class AddWholesaleToLineItems < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_line_items, :wholesale_price, :decimal, precision: 10, scale: 2, null: false
    add_column :spree_line_items, :wholesale_adjustment_total, :decimal, precision: 10, scale: 2, default: "0.0"
    add_column :spree_line_items, :wholesale_additional_tax_total, :decimal, precision: 10, scale: 2, default: "0.0"
    add_column :spree_line_items, :wholesale_promo_total, :decimal, precision: 10, scale: 2, default: "0.0"
    add_column :spree_line_items, :wholesale_included_tax_total, :decimal, precision: 10, scale: 2, default: "0.0", null: false
    add_column :spree_line_items, :wholesale_pre_tax_amount, :decimal, precision: 12, scale: 4, default: "0.0", null: false
    add_column :spree_line_items, :wholesale_taxable_adjustment_total, :decimal, precision: 10, scale: 2, default: "0.0", null: false
    add_column :spree_line_items, :wholesale_non_taxable_adjustment_total, :decimal, precision: 10, scale: 2, default: "0.0", null: false
  end
end
