# frozen_string_literal: true

module Spree
  module ShippingCategoryDecorator
    def self.prepended(base)
      base.enum :carrier_platform, { none: 0, easypost: 1 }, prefix: true
      base.enum :shipping_type, { normal: 0, advanced: 1, roundtrip: 2, inbound: 3, inboundroundtrip: 4 }
      base.enum :label_creation, { normal: 0, advanced: 1 }, prefix: true
    end
  end
end

Spree::ShippingCategory.prepend(Spree::ShippingCategoryDecorator)
