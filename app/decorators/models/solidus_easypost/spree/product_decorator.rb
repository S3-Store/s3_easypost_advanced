# frozen_string_literal: true

module Spree
  module ProductDecorator
    def self.prepended(base)
      base.enum :product_type, { standard: 0, service: 1, trade_in: 2 }

      base.belongs_to :default_stock_location, class_name: 'Spree::StockLocation', optional: true
      base.belongs_to :return_stock_location, class_name: 'Spree::StockLocation', optional: true
      base.belongs_to :service_stock_location, class_name: 'Spree::StockLocation', optional: true
    end
  end
end

Spree::Product.prepend(Spree::ProductDecorator)
