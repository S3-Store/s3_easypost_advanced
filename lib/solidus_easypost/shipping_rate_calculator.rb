# frozen_string_literal: true

module SolidusEasypost
  class ShippingRateCalculator
    def compute(package, rate, shipping_method)
      shipping_method.use_default_shipping_calculator ? calculate_with_default(package, shipping_method) : rate.rate
    end

    private

    def calculate_with_default(package, shipping_method)
      # Use the default shipping calculator logic
      shipping_method.calculator.compute(package)
    end
  end
end
