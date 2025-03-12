class AddBrokerToShippingMethod < ActiveRecord::Migration[7.2]
  def change
    add_column :spree_shipping_methods, :broker, :integer,
      default: 0,
      comment: "Enum values: 0 = none, 1 = easypost"
    add_column :spree_shipping_methods, :carrier_id, :string,
      comment: "ID of the carrier associated with the shipping method"
  end
end
