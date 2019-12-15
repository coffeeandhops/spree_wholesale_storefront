require 'spec_helper'

describe Spree::LineItem do
  # let(:line_item) {create(:line_item)}
  let(:wholesale_order) { create(:wholesale_over_min) }
  let(:wholesale_line_item) { wholesale_order.line_items.first }
  let(:order) { create :order_with_line_items, line_items_count: 1, line_items_price: 19.99 }
  let(:line_item) { order.line_items.first }

  context "wholesale line_items" do
  
    it { is_expected.to respond_to(:wholesale_price) }
    it { is_expected.to respond_to(:is_wholesaleable?) }
    
    it "should get wholesale price" do
      expect(wholesale_line_item.price).to eq(10.0)
    end

    it "should get regular price" do
      expect(line_item.price).to eq(19.99)
    end

  end

  # Test for #3391
  context '#copy_price' do
    it "copies over a variant's prices" do
      wholesale_line_item.price = nil
      wholesale_line_item.cost_price = nil
      wholesale_line_item.currency = nil
      wholesale_line_item.copy_price
      variant = wholesale_line_item.variant
      expect(wholesale_line_item.price).to eq(variant.wholesale_price)
      expect(wholesale_line_item.cost_price).to eq(variant.cost_price)
      expect(wholesale_line_item.currency).to eq(variant.currency)
    end
  end

  # test for copying prices when the vat changes
  context '#update_price' do
    it 'copies over a variants differing price for another vat zone' do
      expect(wholesale_line_item.variant).to receive(:price_including_vat_for).and_return(12)
      wholesale_line_item.price = 10
      wholesale_line_item.update_price
      expect(wholesale_line_item.price).to eq(12)
    end
  end

  # Test for #3481
  context '#copy_tax_category' do
    it "copies over a variant's tax category" do
      wholesale_line_item.tax_category = nil
      wholesale_line_item.copy_tax_category
      expect(wholesale_line_item.tax_category).to eq(line_item.variant.tax_category)
    end
  end

end
