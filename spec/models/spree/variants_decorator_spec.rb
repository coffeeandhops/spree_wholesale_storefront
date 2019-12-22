require 'spec_helper'

describe Spree::Variant do
  describe '.price_in' do
    let(:variant) { create(:variant) }
    let(:wholesale_variant) { create(:wholesale_variant) }


    context 'for non-wholesaleble' do
      subject { variant.price_in(currency).display_amount }

      before do
        variant.prices << create(:price, variant: variant, currency: 'USD', amount: 19.99)
        variant.prices << create(:price, variant: variant, currency: 'EUR', amount: 33.33)
      end
  
      context 'when currency is not specified' do
        let(:currency) { nil }
        it 'returns 0' do
          expect(subject.to_s).to eql '$0.00'
        end
      end
  
      context 'when currency is EUR' do
        let(:currency) { 'EUR' }
  
        it 'returns the value in the EUR' do
          expect(subject.to_s).to eql '€33.33'
        end
      end
  
      context 'when currency is USD' do
        let(:currency) { 'USD' }
  
        it 'returns the value in the USD' do
          expect(subject.to_s).to eql '$19.99'
        end
      end
    end


    context 'for wholesaleble' do
      subject { wholesale_variant.price_in(currency).display_amount }

      before do
        wholesale_variant.prices << create(:price, variant: variant, currency: 'USD', amount: 19.99)
        wholesale_variant.prices << create(:price, variant: variant, currency: 'EUR', amount: 33.33)
      end
  
      context 'when currency is not specified' do
        let(:currency) { nil }
        it 'returns 0' do
          expect(subject.to_s).to eql '$0.00'
        end
      end
  
      context 'when currency is EUR' do
        let(:currency) { 'EUR' }
  
        it 'returns the value in the EUR' do
          expect(subject.to_s).to eql '€33.33'
        end
      end
  
      context 'when currency is USD' do
        let(:currency) { 'USD' }
  
        it 'returns the value in the USD' do
          expect(subject.to_s).to eql '$19.99'
        end
      end
    end

  end


  describe '.wholesale_price_in' do
    let(:variant) { create(:variant) }
    let(:wholesale_variant) { create(:wholesale_variant) }


    context 'for non-wholesaleble' do
      subject { variant.wholesale_price_in(currency).display_amount }

      before do
        variant.prices << create(:price, variant: variant, currency: 'USD', amount: 19.99)
        variant.prices << create(:price, variant: variant, currency: 'EUR', amount: 33.33)
      end
  
      context 'when currency is not specified' do
        let(:currency) { nil }
        it 'returns 0' do
          expect(subject.to_s).to eql '$0.00'
        end
      end
  
      context 'when currency is EUR' do
        let(:currency) { 'EUR' }
  
        it 'returns the value in the EUR' do
          expect(subject.to_s).to eql '€0.00'
        end
      end
  
      context 'when currency is USD' do
        let(:currency) { 'USD' }
  
        it 'returns the value in the USD' do
          expect(subject.to_s).to eql '$0.00'
        end
      end
    end


    context 'for wholesaleble' do
      subject { wholesale_variant.wholesale_price_in(currency).display_amount }

      before do
        wholesale_variant.wholesale_prices << create(:wholesale_price, variant: variant, currency: 'EUR', amount: 33.33)
      end
  
      context 'when currency is not specified' do
        let(:currency) { nil }
        it 'returns 0' do
          expect(subject.to_s).to eql '$0.00'
        end
      end
  
      context 'when currency is EUR' do
        let(:currency) { 'EUR' }
  
        it 'returns the value in the EUR' do
          expect(subject.to_s).to eql '€33.33'
        end
      end
  
      context 'when currency is USD' do
        let(:currency) { 'USD' }
  
        it 'returns the value in the USD' do
          expect(subject.to_s).to eql '$9.25'
        end
      end
    end

  end

  describe "wholesales scope" do
    it "returns the correct number of wholesaleable variants" do
      variant1 = create(:variant, wholesale_price: 8.00)
      variant2 = create(:variant, price: 15.00)
      result = Spree::Variant.wholesales
      result.each { |v| pp "#{v.wholesale_price} - #{v.price}" }
      expect(result.count).to eq(1)
    end
  end
end
