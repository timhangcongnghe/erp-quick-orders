class CreateErpQuickOrdersOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :erp_quick_orders_orders do |t|
      t.string :code
      t.string :customer_name
      t.string :phone
      t.string :email
      t.text :note
      t.decimal :cache_total

      t.timestamps
    end
  end
end
