class AddSchedulePickupInShippingMethod < ActiveRecord::Migration[7.2]
  def change
    add_column :spree_shipping_methods, :schedule_pickup, :boolean, default: false
  end
end
