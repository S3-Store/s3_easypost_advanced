# frozen_string_literal: true

module Spree
  module Api
    module ProductsControllerDecorator
      def permitted_product_attributes
        super + [
          :product_type,
          :default_stock_location_id,
          :return_stock_location_id,
          :service_stock_location_id
        ]
      end
    end
  end
end

Spree::Api::ProductsController.prepend(Spree::Api::ProductsControllerDecorator)
