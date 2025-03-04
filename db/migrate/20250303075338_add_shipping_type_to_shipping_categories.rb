class AddShippingTypeToShippingCategories < ActiveRecord::Migration[7.2]
  def change
    add_column :spree_shipping_categories, :carrier_platform, :integer,
      default: 0,
      comment: "Enum values: 0 = none, 1 = easypost"

    add_column :spree_shipping_categories, :shipping_type, :integer,
      default: 0,
      comment: "Enum values: 0 = normal, 1 = advanced, 2 = roundtrip, 3= inbound, 4 = inboundroundtrip"

    add_column :spree_shipping_categories, :label_creation, :integer,
      default: 0,
      comment: "Enum values: 0 = normal, 1 = advanced"
  end
end
