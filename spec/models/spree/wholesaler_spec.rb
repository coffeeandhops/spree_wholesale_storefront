require 'spec_helper'

describe Spree::Wholesaler do

  context "associations" do
    it { should belong_to :user }
    it { should belong_to :business_address }
 
    it { should validate_presence_of :main_contact }
  end

  context "with a new wholesaler" do
    let(:wholesaler) { build(:wholesaler, user: nil) }

    it 'should create valid wholesaler' do
      wholesaler.user = create(:wholesale_user)
      expect(wholesaler.valid?).to be true
      expect(wholesaler.save).to be true
    end

  end

  context "business address" do
    let(:wholesaler) { create(:wholesaler) }
    let(:business_address) { create(:business_address) }

    it "should except nested attributes" do
      address_atts = {
        company: "ABC COMPANY",
        address1: business_address.address1,
        city: business_address.city,
        country: business_address.country,
        zipcode: business_address.zipcode,
        phone: business_address.phone
      }
      atts = {
        user_id: wholesaler.user_id,
        main_contact: wholesaler.main_contact,
        business_address_attributes: address_atts
      }

      lambda do
        Spree::Wholesaler.create!(atts)
      end.should change(Spree::Wholesaler, :count).by(1)

      lambda do
        Spree::Wholesaler.create!(atts)
      end.should change(Spree::BusinessAddress, :count).by(1)

    end

  end

  
end
