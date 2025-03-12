# frozen_string_literal: true

module SolidusEasypost
  module AddSchedulePickupToAdminShippingMethodForm
    Deface::Override.new(
      virtual_path: 'spree/admin/shipping_methods/_form',
      name: 'add_schedule_pick',
      insert_after: "[data-hook='admin_shipping_method_form_fields']",
      partial: 'spree/admin/shipping_methods/schedule_pickup'
    )
    
    Deface::Override.new(
      virtual_path: 'spree/admin/shipping_methods/_form',
      name: 'add_brocker_field',
      insert_before: "[data-hook='admin_shipping_method_form_availability_fields']",
      partial: 'spree/admin/shipping_methods/broker_field'
    )

    Deface::Override.new(
      virtual_path: 'spree/admin/shipping_methods/_form',
      name: 'remove_next_two_fields_after_code',
      remove: "div[data-hook='admin_shipping_method_form_code'] + div.col-5 + div.col-5"
    )

    Deface::Override.new(
      virtual_path: 'spree/admin/shipping_methods/_form',
      name: 'remove_next_field_after_code',
      remove: "div[data-hook='admin_shipping_method_form_code'] + div.col-5"
    )
  end
end
