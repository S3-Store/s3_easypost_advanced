# frozen_string_literal: true

module SolidusEasypost
  module AddDefaultShippingCalculatorForm
    Deface::Override.new(
      virtual_path: 'spree/admin/shipping_methods/_form',
      name: 'add_default_shipping_calculator',
      insert_after: "[data-hook='admin_shipping_method_form_fields']",
      partial: 'spree/admin/shipping_methods/default_shipping_calculator'
    )
  end
end
