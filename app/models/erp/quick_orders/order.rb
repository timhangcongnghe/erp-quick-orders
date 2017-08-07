module Erp::QuickOrders
  class Order < ApplicationRecord    
    validates :customer_name, :phone, :email, :presence => true
    
    has_many :order_details, dependent: :destroy
    accepts_nested_attributes_for :order_details, :reject_if => lambda { |a| a[:product_id].blank? }, :allow_destroy => true
    
    #save cart
    def save_from_cart(cart)
			order_details = []
			
			cart.cart_items.each do |item|
				
				order_detail = (order_details.select {|o| o.product_id == item.product_id}).first
				if order_detail.nil?
					order_detail = self.order_details.new(product_id: item.product_id, quantity: item.quantity)
					order_details << order_detail
				else
					order_detail.quantity += item.quantity
				end
				
				# gifts
				item.product.products_gifts.each do |gift|
					order_detail = (order_details.select {|o| o.product_id == gift.gift_id}).first
					if order_detail.nil?
						order_detail = self.order_details.new(
								product_id: gift.gift_id,
								quantity: gift.total_quantity(item),
								price: gift.price,
								description: 'Quà tặng')
						order_details << order_detail
					else
						order_detail.quantity += gift.quantity
					end
				end
				
			end
			
			order_details.each(&:save)
		end
    
    before_create :generate_order_code
		after_save :update_cache_total
    
    # get total amount
    def total
			return order_details.sum('price * quantity')
		end
    
    # Update cache total
    def update_cache_total
			self.update_column(:cache_total, self.total)
		end
    
    # Cache total
    def self.cache_total
			self.sum("erp_quick_orders_orders.cache_total")
		end
    
    # Generates a random string from a set of easily readable characters
		def generate_order_code
			size = 5
			charset = %w{0 1 2 3 4 6 7 9 A B C D E F G H I J K L M N O P Q R S T U V W X Y Z}
			self.code = "DH" + Time.now.strftime("%Y").last(2) + (0...size).map{ charset.to_a[rand(charset.size)] }.join
		end
    
  end
end
