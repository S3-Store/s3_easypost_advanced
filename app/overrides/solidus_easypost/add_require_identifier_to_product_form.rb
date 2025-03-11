# frozen_string_literal: true

module SolidusEasypost
  module AddRequireIdentifierToProductForm
    Deface::Override.new(
      virtual_path: 'spree/admin/products/_form',
      name: 'add_require_line_item_identifier_field',
      insert_after: "[data-hook='admin_product_form_track_inventory']",
      partial: 'spree/admin/products/product_require_line_item_identifier_field'
    )
  end
end
