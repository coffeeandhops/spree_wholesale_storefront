require 'spec_helper'

describe Spree::BusinessAddress do
  let(:business_address) { create(:business_address) }
  
  context "associations" do
    it { should validate_presence_of :company }
    it { should validate_presence_of :address1 }
    it { should validate_presence_of :city }
    it { should validate_presence_of :country }
  end

  context "business address" do

    # it { is_expected.to respond_to(:wholesale_price) }
    
    it "returns the business name" do
      expect(business_address.business_name).to eq("ACME Consulting")
      expect(business_address.company).to eq("ACME Consulting")
    end

    it "returns full address" do
      full_address = "#{business_address.address1}, #{business_address.address2}, #{business_address.city}, #{business_address.state_text}, #{business_address.country.try(:iso)}"
      expect(business_address.full_address).to eq(full_address)
    end
  end

  # context 'when validations have been run' do
  #   it 'calls geocode' do
  #     expect(business_address.latitude).to eq(40.7143528)
  #   end
  # end

end
