note
	description: "Summary description for {CART}."
	author: "Jackie Wang and You"
	date: "$Date$"
	revision: "$Revision$"

class
	CART

inherit
	ITERABLE[ORDER] -- when external clients use CART, they can iterate through it one ORDER at a time.

create
	make

feature -- Commands
	make
			-- creates an empty cart
		do
--			create orders.make_empty
			-- supplier's change for LL
			create orders.make
		ensure
			empty_cart: orders.is_empty
		end

feature -- Extend order
	extend_order (o: ORDER)
		do
			-- Exercise
			orders.extend (o)
		end

feature --number of orders
	num_orders: INTEGER
		do
			Result := orders.count
		end

feature -- Iterator
	new_cursor: ITERATION_CURSOR[ORDER]
		do
			Result := orders.new_cursor
		end

feature {NONE} -- Attributes
	-- Hide this orders attribute because its type might change from time to time.
	-- And we do not want such change to impact the clients.
	orders: LINKED_LIST[ORDER]

end
