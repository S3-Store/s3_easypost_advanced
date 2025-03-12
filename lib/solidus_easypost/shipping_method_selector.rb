# frozen_string_literal: true

module SolidusEasypost
  class ShippingMethodSelector
    def shipping_method_for(rate)
      ::Spree::ShippingMethod.find_by(
        carrier: rate.carrier,
        service_level: rate.service,
        carrier_id: rate.carrier_account_id
      )
    end
  end
end
