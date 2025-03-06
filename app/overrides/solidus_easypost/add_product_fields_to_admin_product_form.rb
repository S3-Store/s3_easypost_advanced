# frozen_string_literal: true

module SolidusEasypost
  module AddProductFieldsToAdminProductForm
    Deface::Override.new(
      virtual_path: 'spree/admin/products/_form',
      name: 'add_product_type_and_stock_locations',
      insert_after: "[data-hook='admin_product_form_description']",
      partial: 'spree/admin/products/product_fields'
    )
  end
end
