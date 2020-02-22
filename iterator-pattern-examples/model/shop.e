note
	description: "Summary description for {SHOP}."
	author: "Jackie Wang and You"
	date: "$Date$"
	revision: "$Revision$"

class
	SHOP

create
	make

feature -- Commands
	make
			-- creates an empty shop
		do
			create cart.make
		ensure
			empty_shop: cart.num_orders ~ 0
				-- cart.orders.is_empty
				-- Exercise: define a public query in CART to return the size of cart.
		end

	add_order (o: ORDER)
		do
--			cart.orders.force (o, cart.orders.count + 1)
			-- clent's change for LL

--			cart.orders.extend (o)
			-- since orders from CART is now hidden, we can only call public command from CART
			-- to modify the underlying orders.
			cart.extend_order (o)
		ensure
			-- To Do: Complete Postcondition
			order_added: cart.num_orders ~ (old cart.num_orders + 1)
		end

feature -- Attributes
	cart: CART

feature -- Queries
	checkout: INTEGER
		local
			i: INTEGER
		do
--			from
----				i := cart.orders.lower
--				-- clent's change for LL
--				cart.orders.start
--			until
----				i > cart.orders.upper
--				-- clent's change for LL
--				cart.orders.after
--			loop
--				Result := Result + cart.orders[i].price * cart.orders[i].quantity
----				i := i + 1
--				-- clent's change for LL
--				cart.orders.forth
--			end
			-- Given that the CART class is now iterable,
			-- we can use the across loop over it.
			across cart is o loop
				Result := Result + o.price * o.quantity
			end
		ensure
			nothing_changed: cart.num_orders ~ old cart.num_orders
				-- To Do: Complete this postcondition and run the test.
		end
end
