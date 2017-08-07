class CreateErpQuickOrdersOrderDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :erp_quick_orders_order_details do |t|
      t.references :product, index: true, references: :erp_products_products
      t.references :order, index: true, references: :erp_quick_orders_orders
      t.string :product_name
      t.integer :quantity, default: 1
      t.decimal :price
      t.string :description

      t.timestamps
    end
  end
end
