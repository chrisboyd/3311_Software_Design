note
	description: "Order with product price and quantity"
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	ORDER

create
	make

feature -- Commands
	make (p: INTEGER; q: INTEGER)
			-- creates an order with price `p` and quantity `q`
		require
			positive_price: p > 0
			positive_quantity: q > 0
		do
			price := p
			quantity := q
		ensure
			price_set: price = p
			quantity_set: quantity = q
		end

feature -- Attributes
	price: INTEGER
	quantity: INTEGER

invariant
	positive_price: price > 0
	positive_quantity: quantity > 0
end
