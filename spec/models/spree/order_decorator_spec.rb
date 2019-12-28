require 'spec_helper'

describe Spree::Order do
  context "wholesale orders" do
    let(:order) { create(:order_with_line_item_quantity) }
    let(:wholesale_order) { create(:wholesale_order) }
    let(:wholesale_over_min) { create(:wholesale_over_min, line_items_price: 20.00) }
    let(:user) { create(:user) }
    let(:wholesale_with_normal_user) { create(:wholesale_over_min, user: user) }
    let(:wholesale_under_min) { create(:wholesale_over_min, line_items_quantity: 29, line_items_price: 20.00) }
    let(:wholesale_over_min_multi) { create(:wholesale_over_min_multi, line_items_price: 25.00, line_items_quantity: 20, item_count: 2) }


    it { is_expected.to respond_to(:is_wholesale?) }
    it { is_expected.to respond_to(:wholesale_item_total) }
    
    it "should get wholesale total" do
      expect(wholesale_over_min.wholesale_item_total).to eq(500.0)
    end

    it "should be a wholesale order" do
      expect(wholesale_over_min.is_wholesale?).to be true
    end

    it "should not be a wholesale order if under minimum" do
      expect(wholesale_order.is_wholesale?).to be false
    end

    it "should not be a wholesale order if user is not wholesaler" do
      expect(wholesale_with_normal_user.is_wholesale?).to be false
    end

    it "should not be a wholesale order if under minimum" do
      wholesale_over_min.line_items.first.quantity = 10
      wholesale_over_min.line_items.first.save!
      wholesale_over_min.update_with_updater!

      expect(wholesale_over_min.is_wholesale?).to be false
    end


    it "should be a wholesale order if line_item pushes order over minimum" do
      variant = create(:wholesale_variant, wholesale_price: 11.00, price: 20.00)
      new_item = create(:wholesale_line_item, variant: variant)
      new_item.update_price
      wholesale_under_min.line_items << new_item
      wholesale_under_min.update_with_updater!
      expect(wholesale_under_min.is_wholesale?).to be true
      expect(wholesale_under_min.item_total).to eq(301.00)
    end

    it "should note be a wholesale order if line_item removed" do
      item_price = wholesale_over_min_multi.line_items.last.price

      i = wholesale_over_min_multi.line_items.last
      i.destroy!
      wholesale_over_min_multi.line_items.reload
      wholesale_over_min_multi.update_with_updater!

      expect(wholesale_over_min_multi.is_wholesale?).to be false
      expect(wholesale_over_min_multi.item_total).to eq(item_price * 20)
    end
  end
end
