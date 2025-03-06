# frozen_string_literal: true

RSpec.describe Spree::Product do
  describe 'product type' do
    it 'has the correct enum definition' do
      expect(described_class.product_types).to eq(
        'standard' => 0,
        'service' => 1,
        'trade_in' => 2
      )
    end

    it 'defaults to product type' do
      product = described_class.new
      expect(product.product_type).to eq('standard')
    end
  end

  describe 'associations' do
    it 'has optional stock location references' do
      expect(described_class.column_names).to include(
        'default_stock_location_id',
        'return_stock_location_id',
        'service_stock_location_id'
      )

      association = described_class.reflect_on_association(:default_stock_location)
      expect(association.options).to include(
        class_name: 'Spree::StockLocation',
        optional: true
      )
    end
  end
end
