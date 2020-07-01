module Erp::QuickOrders
  class Order < ApplicationRecord    
    validates :customer_name, :phone, :email, :presence => true
    has_many :order_details, dependent: :destroy
    accepts_nested_attributes_for :order_details, :reject_if => lambda { |a| a[:product_id].blank? }, :allow_destroy => true
    
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
			end
			order_details.each(&:save)
		end
    
    def self.filter(query, params)
      params = params.to_unsafe_hash      
      and_conds = []
      if params["filters"].present?
        params["filters"].each do |ft|
          or_conds = []
          ft[1].each do |cond|
            or_conds << "#{cond[1]["name"]} = '#{cond[1]["value"]}'"
          end
          and_conds << '('+or_conds.join(' OR ')+')' if !or_conds.empty?
        end
      end
      if params["keywords"].present?
        params["keywords"].each do |kw|
          or_conds = []
          kw[1].each do |cond|
            or_conds << "LOWER(#{cond[1]["name"]}) LIKE '%#{cond[1]["value"].downcase.strip}%'"
          end
          and_conds << '('+or_conds.join(' OR ')+')'
        end
      end
      query = query.where(and_conds.join(' AND ')) if !and_conds.empty?
      return query
    end
    
    def self.search(params)
      query = self.order("created_at DESC")
      query = self.filter(query, params)
      return query
    end
    
    before_create :generate_order_code
		after_save :update_cache_total
		
    def total
			return order_details.sum('price * quantity')
		end
    
    def update_cache_total
			self.update_column(:cache_total, self.total)
		end
    
    def self.cache_total
			self.sum("erp_quick_orders_orders.cache_total")
		end
    
		def generate_order_code
			size = 5
			charset = %w{0 1 2 3 4 6 7 9 A B C D E F G H I J K L M N O P Q R S T U V W X Y Z}
			self.code = "DH" + Time.now.strftime("%Y").last(2) + (0...size).map{ charset.to_a[rand(charset.size)] }.join
		end
  end
end