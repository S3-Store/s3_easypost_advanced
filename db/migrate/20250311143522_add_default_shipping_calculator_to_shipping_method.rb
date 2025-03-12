class AddDefaultShippingCalculatorToShippingMethod < ActiveRecord::Migration[8.0]
  def change
    add_column :spree_shipping_methods, :use_default_shipping_calculator, :boolean, default: false
  end
end
