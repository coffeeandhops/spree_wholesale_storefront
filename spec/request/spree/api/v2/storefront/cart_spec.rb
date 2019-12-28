require 'spec_helper'

describe 'API V2 Storefront Cart Spec', type: :request do
  let(:default_currency) { 'USD' }
  let(:store) { create(:store, default_currency: default_currency) }
  let(:currency) { store.default_currency }
  let(:user)  { create(:user) }
  let(:wholesale_user)  { create(:wholesale_user) }
  let(:order) { create(:order, user: user, store: store, currency: currency) }

  let(:wholesale_over_min) { create(:wholesale_over_min, line_items_price: 20.00) }
  let(:wholesale_over_min_multi) { create(:wholesale_over_min_multi, line_items_price: 25.00, line_items_quantity: 20, item_count: 2) }
  let(:wholesale_under_min) { create(:wholesale_over_min, line_items_quantity: 29, line_items_price: 20.00) }
  let(:variant) { create(:variant) }

  include_context 'API v2 tokens'

  let(:wholesale_token) { Doorkeeper::AccessToken.create!(resource_owner_id: wholesale_user.id, expires_in: nil) }
  let(:wholesale_headers_bearer) { { 'Authorization' => "Bearer #{wholesale_token.token}" } }
  let(:wholesale_headers_order_token) { { 'X-Spree-Order-Token' => wholesale_over_min.token } }

  let(:wholesale_token_multi) { Doorkeeper::AccessToken.create!(resource_owner_id: wholesale_user.id, expires_in: nil) }
  let(:wholesale_headers_bearer_multi) { { 'Authorization' => "Bearer #{wholesale_token_multi.token}" } }
  let(:wholesale_headers_order_token_multi) { { 'X-Spree-Order-Token' => wholesale_over_min_multi.token } }


  let(:wholesale_under_token) { Doorkeeper::AccessToken.create!(resource_owner_id: wholesale_user.id, expires_in: nil) }
  let(:wholesale_under_headers_bearer) { { 'Authorization' => "Bearer #{wholesale_under_token.token}" } }
  let(:wholesale_under_headers_order_token) { { 'X-Spree-Order-Token' => wholesale_under_min.token } }
  let(:wholesale_variant) { create(:wholesale_variant, wholesale_price: 11.00, price: 20.00) }

  describe 'cart#add_item' do
    let(:options) { {} }
    let(:params) { { variant_id: variant.id, quantity: 5, options: options, include: 'variants,line_items,user' } }
    let(:execute) { post '/api/v2/storefront/cart/add_item', params: params, headers: headers }

    before do
      Spree::PermittedAttributes.line_item_attributes << :cost_price
    end

    context 'as a wholesale user' do
      let(:headers) { wholesale_under_headers_order_token }
      before { execute }

      it_behaves_like 'returns 200 HTTP status'

      it 'should not be a wholesale order' do
        expect(json_response['data']).to have_attribute(:is_wholesale).with_value(false)
        expect(json_response['data']).to have_attribute(:wholesale_item_total).with_value("290.0")
        expect(json_response['data']).to have_attribute(:display_wholesale_item_total).with_value("$290.00")
      end

      context 'add wholesale item to push over minimum value' do
        let(:params) { { variant_id: wholesale_variant.id, quantity: 5, options: options, include: 'variants,line_items,user' } }
        before { execute }

        it 'returns correct wholesale response' do
          expect(json_response['data']).to have_attribute(:is_wholesale).with_value(true)
          expect(json_response['data']).to have_attribute(:wholesale_item_total).with_value("345.0")
          expect(json_response['data']).to have_attribute(:display_wholesale_item_total).with_value("$345.00")
        end
      end

    end

    context 'as a non wholesale user' do
      let(:headers) { headers_order_token }
      before { execute }

      it_behaves_like 'returns 200 HTTP status'

      it 'should not be a wholesale order' do
        expect(json_response['data']).to have_attribute(:is_wholesale).with_value(false)
      end

      context 'add wholesale item to push over minimum value' do
        let(:params) { { variant_id: wholesale_variant.id, quantity: 40, options: options, include: 'variants,line_items,user' } }
        before { execute }

        it 'returns correct wholesale response' do
          expect(json_response['data']).to have_attribute(:is_wholesale).with_value(false)
          expect(json_response['data']).to have_attribute(:wholesale_item_total).with_value("440.0")
          expect(json_response['data']).to have_attribute(:display_wholesale_item_total).with_value("$440.00")
          expect(json_response['data']).to have_attribute(:display_total).with_value("$800.00")
        end
      end

    end

  end

  describe 'cart#remove_line_item' do
    let(:headers) { wholesale_headers_order_token_multi }
    let(:execute) { delete "/api/v2/storefront/cart/remove_line_item/#{line_item.id}", headers: headers }

    context 'removes line item' do
      before { execute }

      context 'without line items' do
        
        let!(:line_item) { create(:line_item) }

        it_behaves_like 'returns 404 HTTP status'
      end

      context 'containing line item' do
        let!(:line_item) { wholesale_over_min_multi.line_items.first }

        it_behaves_like 'returns 200 HTTP status'

        it 'removes line item from the cart' do
          expect(wholesale_over_min_multi.line_items.count).to eq(1)
          expect(json_response['data']).to have_attribute(:is_wholesale).with_value(false)
          expect(json_response['data']).to have_attribute(:display_total).with_value("$500.00")
        end
      end
    end
  end

  describe 'cart#empty' do
    let(:execute) { patch '/api/v2/storefront/cart/empty', headers: headers }

    shared_examples 'emptying the order' do
      before { execute }

      it_behaves_like 'returns 200 HTTP status'

      it 'empties the order' do
        expect(wholesale_over_min_multi.reload.line_items.count).to eq(0)
        expect(json_response['data']).to have_attribute(:display_total).with_value("$0.00")
      end
    end

    context 'as a signed in user' do
      let(:headers) { wholesale_headers_order_token_multi }

      context 'with existing order with line item' do
        # include_context 'creates order with line item'

        it_behaves_like 'emptying the order'
      end

      it_behaves_like 'no current order'
    end
  end

  describe 'cart#set_quantity' do
    let(:line_item) { wholesale_over_min_multi.line_items.first }
    let(:params) { { order: wholesale_over_min_multi, line_item_id: line_item.id, quantity: 5 } }
    let(:execute) { patch '/api/v2/storefront/cart/set_quantity', params: params, headers: headers }

    shared_examples 'wrong quantity parameter' do
      it_behaves_like 'returns 422 HTTP status'

      it 'returns an error' do
        expect(json_response[:error]).to eq('Quantity has to be greater than 0')
      end
    end

    shared_examples 'set quantity' do
      context 'changes the quantity of line item' do
        before { execute }

        it_behaves_like 'returns 200 HTTP status'

        it 'successfully changes the quantity' do
          expect(line_item.reload.quantity).to eq(5)
          expect(json_response['data']).to have_attribute(:display_total).with_value("$625.00")
        end
      end

      context '0 passed as quantity' do
        before do
          params[:quantity] = 0
          execute
        end

        it_behaves_like 'wrong quantity parameter'
      end

      context 'quantity not passed' do
        before do
          params[:quantity] = nil
          execute
        end

        it_behaves_like 'wrong quantity parameter'
      end

      it_behaves_like 'no current order'
    end

    context 'as a signed in user' do
      let(:headers) { wholesale_headers_order_token_multi }

      it_behaves_like 'set quantity'
    end
  end

end