class AddEasypostTrackerToShipments < ActiveRecord::Migration[7.2]
  def change
    add_column :spree_shipments, :easy_post_inbound_tracker_id, :string
    add_column :spree_shipments, :easy_post_tracker_id, :string
  end
end
