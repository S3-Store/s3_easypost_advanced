class AddRequireIdentifierToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :spree_products, :require_line_item_identifier, :boolean,
      default: false,
      comment: 'Product require an Line Item identifier'
  end
end
