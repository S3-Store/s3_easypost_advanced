# frozen_string_literal: true

module Spree
  module ApiConfigurationDecorator
    def product_attributes
      super + [
        :product_type,
        :default_stock_location_id,
        :return_stock_location_id,
        :service_stock_location_id
      ]
    end
  end
end

Spree::ApiConfiguration.prepend(Spree::ApiConfigurationDecorator)
