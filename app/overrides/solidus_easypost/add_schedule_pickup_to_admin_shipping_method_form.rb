# frozen_string_literal: true

module SolidusEasypost
  module AddSchedulePickupToAdminShippingMethodForm
    Deface::Override.new(
      virtual_path: 'spree/admin/shipping_methods/_form',
      name: 'add_schedule_pick',
      insert_after: "[data-hook='admin_shipping_method_form_fields']",
      partial: 'spree/admin/shipping_methods/schedule_pickup'
    )
  end
end
