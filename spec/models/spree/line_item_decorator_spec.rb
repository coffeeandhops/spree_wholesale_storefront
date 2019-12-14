require 'spec_helper'

describe Spree::LineItem do
  context "wholesale line_items" do
    let(:wholesale_line_item) {create(:wholesale_line_item)}
    let(:line_item) {create(:line_item)}

    it { is_expected.to respond_to(:wholesale_price) }
    it { is_expected.to respond_to(:is_wholesaleable?) }
    
    it "should get wholesale price" do
      expect(wholesale_line_item.price).to eq(9.25)
    end

    it "should get regular price" do
      expect(line_item.price).to eq(19.99)
    end

  end
end
