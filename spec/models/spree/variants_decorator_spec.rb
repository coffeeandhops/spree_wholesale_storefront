require 'spec_helper'

describe Spree::Variant do
  describe "wholesale variants" do
    it "returns the wholesale price if it is present" do
      variant = create(:variant, wholesale_price: 8.00)
      expected = Spree::Price.new(variant_id: variant.id, currency: "USD", amount: variant.wholesale_price)

      result = variant.price_in("USD")

      expect(result.variant_id).to eq(expected.variant_id)
      expect(result.amount.to_f).to eq(expected.amount.to_f)
      expect(result.currency).to eq(expected.currency)
    end

    it "returns the normal price if it is not wholesaleable" do
      variant = create(:variant, price: 15.00)
      expected = Spree::Price.new(variant_id: variant.id, currency: "USD", amount: variant.price)

      result = variant.price_in("USD")

      expect(result.variant_id).to eq(expected.variant_id)
      expect(result.amount.to_f).to eq(expected.amount.to_f)
      expect(result.currency).to eq(expected.currency)
    end

    it "returns the correct number of wholesaleable variants" do
      variant1 = create(:variant, wholesale_price: 8.00)
      variant2 = create(:variant, price: 15.00)

      result = Spree::Variant.wholesales

      expect(result.count).to eq(1)
    end
  end
end
