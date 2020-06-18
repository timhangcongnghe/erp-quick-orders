module Erp::QuickOrders
  class OrderDetail < ApplicationRecord
    belongs_to :order, class_name: 'Erp::QuickOrders::Order'
    belongs_to :product, class_name: 'Erp::Products::Product'
    before_validation :update_current_price_from_product
    before_validation :update_current_name_from_product
    after_save :update_quick_order_cache_total
    
    def update_current_price_from_product
      if self.price.nil?
        self.price = product.product_price
      end    
    end
      
    def update_current_name_from_product
      if self.product_name.nil?
        self.product_name = product.get_short_name
      end    
    end
    
    def update_quick_order_cache_total
			if order.present?
				order.update_cache_total
			end
		end
    
    STYLE_GIFT = 'gift'
    
    def total
      quantity*price
    end
    
    def product_code
			product.present? ? product.code : ""
		end
    
    def display_product_name
			product.present? ? product.get_short_name : ""
		end
  end
end
