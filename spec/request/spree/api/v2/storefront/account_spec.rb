require 'spec_helper'

RSpec.describe 'API V2 Storefront Account Spec', type: :request do
  include_context 'API v2 tokens'
  let!(:user)  { create(:wholesale_user_with_addresses) }
  let(:headers) { headers_bearer }
  describe 'account#show' do
    before { get '/api/v2/storefront/account', headers: headers }

    it_behaves_like 'returns 200 HTTP status'

    it 'return JSON API payload of User and associations (default billing, shipping address and wholesaler)' do
      # expect(json_response['data']).to have_id(user.id.to_s)
      expect(json_response['data']).to have_type('user')
      expect(json_response['data']).to have_relationships(:default_shipping_address, :default_billing_address)

      expect(json_response['data']).to have_attribute(:email).with_value(user.email)
      expect(json_response['data']).to have_attribute(:store_credits).with_value(user.total_available_store_credit)
      expect(json_response['data']).to have_attribute(:completed_orders).with_value(user.orders.complete.count)
      expect(json_response['data']).to have_attribute(:wholesaler).with_value(user.wholesaler?)
    end

    context 'with params "include=wholesaler"' do
      before { get '/api/v2/storefront/account?include=wholesaler', headers: headers }

      it 'returns account data with included wholesaler' do
        expect(json_response['included']).to    include(have_type('wholesaler'))
        expect(json_response['included'][0]).to eq(Spree::V2::Storefront::WholesalerSerializer.new(user.wholesaler).as_json['data'])
      end
    end
  end
end
