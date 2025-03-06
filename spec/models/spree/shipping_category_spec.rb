# frozen_string_literal: true

RSpec.describe Spree::ShippingCategory do
  describe 'shipping type' do
    it 'has the correct enum definition' do
      expect(described_class.shipping_types).to eq(
        'normal' => 0,
        'advanced' => 1,
        'roundtrip' => 2,
        'inbound' => 3,
        'inboundroundtrip' => 4
      )
    end

    it 'defaults to shipping type' do
      shipping_category = described_class.new
      expect(shipping_category.shipping_type).to eq('normal')
    end
  end

  describe 'carrier platform' do
    it 'has the correct enum definition' do
      expect(described_class.carrier_platforms).to eq(
        'none' => 0,
        'easypost' => 1
      )
    end

    it 'defaults to carrier platform' do
      shipping_category = described_class.new
      expect(shipping_category.carrier_platform).to eq('none')
    end
  end

  describe 'label creation' do
    it 'has the correct enum definition' do
      expect(described_class.label_creations).to eq(
        'normal' => 0,
        'advanced' => 1
      )
    end

    it 'defaults to label creation' do
      shipping_category = described_class.new
      expect(shipping_category.label_creation).to eq('normal')
    end
  end
end
