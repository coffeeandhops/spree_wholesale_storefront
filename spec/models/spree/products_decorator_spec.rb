require 'spec_helper'

describe Spree::Product do
  context "wholesale products" do
    let(:product) { create(:product) }
    let(:product2) { create(:product) }
    let(:variant) { product.master }
    let(:variant2) { product2.master }

    it { is_expected.to respond_to(:wholesale_price) }
    
    it "returns the wholesale price if it is present" do
      variant.wholesale_price = 8.50
      expect(product.wholesale_price).to eq(8.50)
    end

    it { is_expected.to respond_to(:is_wholesaleable?) }

    it "should return true for wholesalable product" do
      variant.wholesale_price = 8.50
      expect(product.is_wholesaleable?).to be true
    end
    
    it "should return wholesalable products" do
      variant.wholesale_price = 8.50
      variant.save!
      variant.reload

      wholesale_products = Spree::Product.wholesaleable
      expect(wholesale_products.count).to eq(1)
    end

    context 'when master default wholesale price changed' do
      before do
        master = product.master
        master.wholesale_price = 11
        master.save!
        product.master.wholesale_price = 12
      end

      it 'saves the master' do
        expect(product.master).to receive(:save!)
        product.save
      end

      it 'saves the default wholesale price' do
        expect(product.master.default_wholesale_price).to receive(:save)
        product.save
      end
    end

  end
end
