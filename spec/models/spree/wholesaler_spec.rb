require 'spec_helper'

describe Spree::Wholesaler do

  context "associations" do
    it { should belong_to :user }
 
    it { should validate_presence_of :company }
    it { should validate_presence_of :buyer_contact }
    it { should validate_presence_of :phone }
  end

  context "with a new wholesaler" do
    let(:wholesaler) { build(:wholesaler, user: nil) }

    it 'should create valid wholesaler' do
      wholesaler.user = create(:wholesale_user)
      expect(wholesaler.valid?).to be true
      expect(wholesaler.save).to be true
    end

  end
end
