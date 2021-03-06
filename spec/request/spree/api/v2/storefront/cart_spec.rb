require 'spec_helper'

describe 'API V2 Storefront Cart Spec', type: :request do
  let(:default_currency) { 'USD' }
  let(:store) { create(:store, default_currency: default_currency) }
  let(:currency) { store.default_currency }
  let(:user)  { create(:user) }
  let(:wholesale_user)  { create(:wholesale_user) }
  let(:order) { create(:order_with_line_items, user: user, store: store, currency: currency, line_items_count: 29) }
  let(:order_token) { { 'X-Spree-Order-Token' => order.token } }

  let(:wholesale_over_min) { create(:wholesale_over_min, line_items_price: 20.00) }
  let(:wholesale_over_min_multi) { create(:wholesale_over_min_multi, line_items_quantity: 20, item_count: 2) }
  let(:wholesale_with_large_no) { create(:wholesale_with_large_no, line_items_quantity: 1, item_count: 29) }
  
  let(:wholesale_under_min) { create(:wholesale_over_min, line_items_quantity: 29, line_items_price: 20.00) }
  let(:variant) { create(:variant) }

  include_context 'API v2 tokens'

  let(:wholesale_token) { Doorkeeper::AccessToken.create!(resource_owner_id: wholesale_user.id, expires_in: nil) }
  let(:wholesale_headers_bearer) { { 'Authorization' => "Bearer #{wholesale_token.token}" } }
  let(:wholesale_headers_order_token) { { 'X-Spree-Order-Token' => wholesale_over_min.token } }

  let(:wholesale_token_multi) { Doorkeeper::AccessToken.create!(resource_owner_id: wholesale_user.id, expires_in: nil) }
  let(:wholesale_headers_bearer_multi) { { 'Authorization' => "Bearer #{wholesale_token_multi.token}" } }
  let(:wholesale_headers_order_token_multi) { { 'X-Spree-Order-Token' => wholesale_over_min_multi.token } }
  let(:wholesale_with_large_no_order_token) { { 'X-Spree-Order-Token' => wholesale_with_large_no.token } }


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
        currency = wholesale_under_min.currency
        wholesale_price = wholesale_under_min.line_items.first.variant.wholesale_price
        price = wholesale_under_min.line_items.first.variant.wholesale_price
        qty = wholesale_under_min.line_items.first.quantity
        expected_wholesale_total = wholesale_price * qty
        display_total = ::Spree::Money.new(expected_wholesale_total, currency: currency).to_s
        expect(json_response['data']).to have_attribute(:is_wholesale).with_value(false)
        expect(json_response['data']).to have_attribute(:wholesale_item_total).with_value(expected_wholesale_total.to_s)
        expect(json_response['data']).to have_attribute(:display_wholesale_item_total).with_value(display_total)
      end

      context 'add wholesale item to push over minimum value' do
        let(:params) { { variant_id: wholesale_variant.id, quantity: 5, options: options, include: 'variants,line_items,user' } }
        before { execute }

        it 'returns correct wholesale response' do
          expected_wholesale_total = (9.25 * 29) + (11.00 * 5)
          display_total = ::Spree::Money.new(expected_wholesale_total, currency: currency).to_s
          expect(json_response['data']).to have_attribute(:is_wholesale).with_value(true)
          expect(json_response['data']).to have_attribute(:wholesale_item_total).with_value(expected_wholesale_total.to_s)
          expect(json_response['data']).to have_attribute(:display_wholesale_item_total).with_value(display_total)
        end
      end

      # it 'should not fail when item is out of stock' do
      # end
      
      context 'should handle a shit ton in the cart' do
      
        let(:params) { { variant_id: wholesale_variant.id, quantity: 100000, options: options, include: 'variants,line_items,user' } }
        before { execute }
        it 'returns correct wholesale response for large qty' do
          expected_wholesale_total = (9.25 * 29) + (11.00 * 100000)
          display_total = ::Spree::Money.new(expected_wholesale_total, currency: currency).to_s
          expect(json_response['data']).to have_attribute(:is_wholesale).with_value(true)
          expect(json_response['data']).to have_attribute(:wholesale_item_total).with_value(expected_wholesale_total.to_s)
          expect(json_response['data']).to have_attribute(:display_wholesale_item_total).with_value(display_total)
        end

        context "non wholesale order" do
          let(:headers) { order_token }
          let(:params) { { variant_id: wholesale_variant.id, quantity: 1, options: options, include: 'variants,line_items,user' } }
          before { execute }
          it 'returns correct response for large no line items' do
            expected_total = (10 * 29 * 1) + (20.00 * 1)
            display_total = ::Spree::Money.new(expected_total, currency: currency).to_s
            # pp json_response['data']
            expect(json_response['data']).to have_attribute(:is_wholesale).with_value(false)
            expect(json_response['data']).to have_attribute(:item_total).with_value(expected_total.to_s)
            expect(json_response['data']).to have_attribute(:display_item_total).with_value(display_total)
            expect(json_response['data']).to have_attribute(:wholesale_item_total).with_value("11.0")
            expect(json_response['data']).to have_attribute(:display_wholesale_item_total).with_value("$11.00")
          end
        end

        it 'should not be wholesale' do
          expect(wholesale_with_large_no.line_items.count).to be(29)
          expect(wholesale_with_large_no.is_wholesale?).to be false
        end

        context "large number of line_items" do

          let(:headers) { wholesale_with_large_no_order_token }
          # let(:headers) { order_token }
          let(:params) { { variant_id: wholesale_variant.id, quantity: 28, options: options, include: 'variants,line_items,user' } }
          before { execute }
          it 'returns correct wholesale response for large no line items' do
            expected_wholesale_total = (9.25 * 29 * 1) + (11.00 * 28)
            # expected_wholesale_total = (10.0 * 29 * 1) + (11.00 * 28)
            display_total = ::Spree::Money.new(expected_wholesale_total, currency: currency).to_s
            expect(json_response['data']).to have_attribute(:is_wholesale).with_value(true)
            expect(json_response['data']).to have_attribute(:wholesale_item_total).with_value(expected_wholesale_total.to_s)
            expect(json_response['data']).to have_attribute(:display_wholesale_item_total).with_value(display_total)
          end
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
          expected_wholesale_total = 11.0 * 40.0
          display_total = ::Spree::Money.new(expected_wholesale_total, currency: currency).to_s
          expect(json_response['data']).to have_attribute(:is_wholesale).with_value(false)
          expect(json_response['data']).to have_attribute(:wholesale_item_total).with_value(expected_wholesale_total.to_s)
          expect(json_response['data']).to have_attribute(:display_wholesale_item_total).with_value(display_total)
          expect(json_response['data']).to have_attribute(:display_total).with_value("$1,090.00")
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

        it 'from the cart' do
          expected_total = 19.99 * 20
          display_total = ::Spree::Money.new(expected_total, currency: currency).to_s
          expect(wholesale_over_min_multi.line_items.count).to eq(1)
          expect(json_response['data']).to have_attribute(:is_wholesale).with_value(false)
          expect(json_response['data']).to have_attribute(:display_total).with_value(display_total.to_s)
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
          expected_total = (5 * 19.99) + (20 * 19.99) # 499.75
          expected_wholesale = (5 * 9.25) + (20 * 9.25) # 231.25
          display_total = ::Spree::Money.new(expected_total, currency: currency).to_s
          display_wholesale_total = ::Spree::Money.new(expected_wholesale, currency: currency).to_s

          expect(line_item.reload.quantity).to eq(5)
          expect(json_response['data']).to have_attribute(:display_total).with_value(display_total)
          expect(json_response['data']).to have_attribute(:display_wholesale_item_total).with_value(display_wholesale_total)
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
