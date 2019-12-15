require 'spec_helper'

describe Spree::Order do
  context "wholesale orders" do
    let(:order) { create(:order_with_line_item_quantity) }
    let(:wholesale_order) { create(:wholesale_order) }
    let(:wholesale_over_min) { create(:wholesale_over_min) }
    let(:user) { create(:user) }
    let(:wholesale_with_normal_user) { create(:wholesale_over_min, user: user) }


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
      pp wholesale_over_min
      pp wholesale_over_min.line_items.first
      pp wholesale_over_min.line_items.first.variant.price
      expect(wholesale_over_min.is_wholesale?).to be false
    end

  end
end
