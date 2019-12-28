require 'spec_helper'

describe 'API V2 Storefront Products Spec', type: :request do
  let(:product) { create(:product) }

  describe 'products#show' do
    context 'with existing product' do
      before { get "/api/v2/storefront/products/#{product.slug}" }

      it_behaves_like 'returns 200 HTTP status'

      it 'returns a valid JSON response' do
        expect(json_response['data']).to have_id(product.id.to_s)

        expect(json_response['data']).to have_type('product')

        expect(json_response['data']).to have_attribute(:wholesale_price).with_value(product.wholesale_price)
        expect(json_response['data']).to have_attribute(:display_wholesale_price).with_value(product.display_wholesale_price.to_s)
      end
    end
  end
end