require 'spec_helper'

describe Spree::BusinessAddress do
  
  context "associations" do
    it { should validate_presence_of :company }
    it { should validate_presence_of :address1 }
    it { should validate_presence_of :city }
    it { should validate_presence_of :country }
  end

  context "business address" do
    let(:business_address) { create(:business_address) }

    # it { is_expected.to respond_to(:wholesale_price) }
    
    it "returns the business name" do
      expect(business_address.business_name).to eq("ACME Consulting")
      expect(business_address.company).to eq("ACME Consulting")
    end

  end
end
