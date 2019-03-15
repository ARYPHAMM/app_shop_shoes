class CartProduct < ApplicationRecord
	belongs_to :cart
	belongs_to :product
	# belongs_to :payment
	def total_price
		quantity * price
	end
end