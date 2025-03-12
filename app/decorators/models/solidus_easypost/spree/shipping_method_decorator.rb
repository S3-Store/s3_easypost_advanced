# frozen_string_literal: true

module Spree
  module ShippingMethodDecorator
    def self.prepended(base)
      base.enum :broker, { none: 0, easypost: 1 }, prefix: true
    end
  end
end

Spree::ShippingMethod.prepend(Spree::ShippingMethodDecorator)
