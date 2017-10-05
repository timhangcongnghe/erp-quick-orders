class AddInvoiceAndAddressToErpQuickOrdersOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :erp_quick_orders_orders, :invoice, :boolean, default: false
    add_column :erp_quick_orders_orders, :address, :string
    add_reference :erp_quick_orders_orders, :district, index: true, references: :erp_areas_districts
    add_reference :erp_quick_orders_orders, :state, index: true, references: :erp_areas_states    
  end
end
