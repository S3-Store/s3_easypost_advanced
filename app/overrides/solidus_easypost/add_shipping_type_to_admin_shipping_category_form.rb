# frozen_string_literal: true

module SolidusEasypost
  module AddShippingTypeToAdminShippingCategoryForm
    Deface::Override.new(
      virtual_path: 'spree/admin/shipping_categories/_form',
      name: 'add_shipping_type_field',
      insert_after: "[data-hook='name']",
      partial: 'spree/admin/shipping_categories/shipping_fields'
    )
  end
end
