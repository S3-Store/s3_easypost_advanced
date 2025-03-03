# frozen_string_literal: true

class AddProductFieldsToSpreeProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_products, :product_type, :integer,
      default: 0,
      comment: 'Classification: 0=standard, 1=service, 2=trade-in'

    add_reference :spree_products, :default_stock_location,
      foreign_key: { to_table: :spree_stock_locations },
      comment: 'Primary fulfillment stock location',
      index: true,
      null: true

    add_reference :spree_products, :return_stock_location,
      foreign_key: { to_table: :spree_stock_locations },
      comment: 'Return processing stock location',
      index: true,
      null: true

    add_reference :spree_products, :service_stock_location,
      foreign_key: { to_table: :spree_stock_locations },
      comment: 'Service inventory stock location',
      index: true,
      null: true
  end
end
