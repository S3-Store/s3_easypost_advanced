class AddRequiresIdentifierToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :spree_products, :requires_identifier, :boolean,
      default: false,
      comment: 'Product requires an identifier'
  end
end
