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
        self.product_name = product.name
      end    
    end
    
    # update order cache total
    def update_quick_order_cache_total
			if order.present?
				order.update_cache_total
			end
		end
    
    # class const
    STYLE_GIFT = 'gift'
    
    def total
      quantity*price
    end
    
    # display product code
    def product_code
			product.present? ? product.code : ""
		end
    
    # display product name
    def display_product_name
			product.present? ? product.name : ""
		end
  end
end
