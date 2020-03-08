note
	description: "[
		Tests of the Iterator Design Patterns.
		]"
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision 19.05$"

class
	TEST_ITERATORS

inherit

	ES_TEST

create
	make

feature {NONE} -- Initialization

	make
			-- initialize tests
		do
			add_boolean_case (agent test_cart_value)
			add_boolean_case (agent test_book)
		end

feature -- tests

	test_cart_value: BOOLEAN
		local
			shop: SHOP
			coffee, bagel: ORDER
		do
			comment ("t0: Test calculation of cart value")
			create shop.make
			Result := shop.checkout = 0
			check Result end
			create coffee.make (2, 3)
			create bagel.make (3, 4)
			shop.add_order (coffee)
			shop.add_order (bagel)
			Result := shop.checkout = 2 * 3 + 3 * 4
			
		end

	test_book: BOOLEAN
		local
			b: BOOK[INTEGER]
			--a: ARRAY[TUPLE[STRING, INTEGER]]
			c: INTEGER
		do
			comment ("t1: Test iterator of book")
			create b.make
			b.add_record ("chris", 1)
			b.add_record ("jill", 2)
			c := 0
			-- Exercise: add serveral orders into the book

				across
					b is iter
				loop
					check attached {STRING} iter[1] as n
							and attached {INTEGER} iter[2] as i
					then
						c := c + 1
					end
				end
			check c = 2 end

			--create a.make_empty
--			across b is t
--			loop
--				io.put_string (t[1])
--				io.put_integer (t[2]) t[2] is of type order, print price and quantity
				-- t[1] is of static type ANY, but dynamic type STRING
				-- t[2] is of static type ANY, but dynamic type ORDER	
				-- In order to create a tuple of type [STRING, ORDER]
				-- we need to cast (using the check ... then ... end syntax) t[1] to STRING,
				-- and cast t[2] to ORDER.	
--				check 	attached {STRING} t[1] as n
--							and
--							attached {ORDER} t[2] as o
--				then
--					a.force ([n, o], a.count + 1)
--				end
--			end
		end
end
