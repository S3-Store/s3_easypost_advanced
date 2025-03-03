# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'API::Products' do
  let(:admin_user) { create(:admin_user) }
  let(:valid_headers) { { 'X-Spree-Token' => admin_user.spree_api_key } }
  let(:product) { create(:product, product_type: :service) }
  let(:stock_location) { create(:stock_location) }

  before do
    allow(Spree.user_class).to receive(:find_by)
      .with(hash_including(:spree_api_key))
      .and_return(admin_user)
  end

  describe 'Retrieving product details' do
    context 'when requesting an existing product' do
      before { get "/api/products/#{product.id}", headers: valid_headers }

      it 'returns comprehensive product information', :aggregate_failures do
        expect(response).to have_http_status(:ok)

        product_data = response.parsed_body
        expect(product_data).to include(
          'product_type' => 'service',
          'default_stock_location_id' => product.default_stock_location_id,
          'return_stock_location_id' => product.return_stock_location_id,
          'service_stock_location_id' => product.service_stock_location_id
        )
      end
    end
  end

  describe 'Modifying product attributes' do
    context 'when updating product classification and inventory locations' do
      let(:update_payload) do
        {
          product: {
            product_type: 'trade_in',
            default_stock_location_id: stock_location.id,
            return_stock_location_id: stock_location.id
          }
        }
      end

      before do
        put "/api/products/#{product.id}",
          params: update_payload,
          headers: valid_headers
      end

      it 'successfully persists the changes', :aggregate_failures do
        expect(response).to have_http_status(:ok)

        product.reload
        expect(product).to have_attributes(
          product_type: 'trade_in',
          default_stock_location_id: stock_location.id,
          return_stock_location_id: stock_location.id
        )
      end
    end
  end
end
