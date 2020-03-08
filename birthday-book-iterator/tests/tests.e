note
	description: "Test BIRTHDAY_BOOK"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TESTS
inherit
	ES_TEST

create
	make

feature {NONE} -- Initialization

	make
			-- create test suite
		do
			add_boolean_case (agent t1)
			add_boolean_case (agent t2)
		end

feature -- tests


	t1: BOOLEAN
		local
			feb17: BIRTHDAY
			bb: BIRTHDAY_BOOK
			a: ARRAY[NAME]
			l_name: NAME
			l_birthday: BIRTHDAY
			jack,jill,max: NAME
		do
			comment("t1: test birthday book")
			create jack.make ("Jack"); create jill.make ("Jill")
			create max.make ("Max")
			create feb17.make (02, 17) -- Feb 17
			create bb.make
			-- add birthdays for Jack and Jill
			bb.put (jack, [14,01])  -- Jan 14
			bb.put (jill, [17,02])  -- Feb 17
			Result := bb.model.count = 2
				and bb.model[jack] ~ [14,01]
				and bb.model[jill] ~ [17,02]
				and bb.out ~ "{ Jack -> (14,1), Jill -> (17,2) }"
			check Result end
			-- Add birthday for Max
			bb.put (max, [17,02])
			assert_equal ("Max's birthday", bb.model[max], feb17)
			-- Whose birthday is Feb 17th?
			a := bb.remind ([17,02])
			Result := a.count = 2
				and a.has (max)
				and a.has (jill)
				and not a.has (jack)
			check Result end
			-- check efficienthash table implementation
			across bb.model as cursor loop
				l_name := cursor.item.first
				l_birthday := cursor.item.second
				check
					bb.imp.has (l_name)
					and then bb.imp[l_name] ~ l_birthday
				end
			end
		end

	t2: BOOLEAN
		local
			bb: BIRTHDAY_BOOK
			jack, jill, max: NAME
			feb17: BIRTHDAY
			tuples: LINKED_LIST[TUPLE[bd: BIRTHDAY; n: NAME]]
		do
			comment ("t2: test of iterable birthday book")
			create bb.make

			create jack.make ("Jack"); create jill.make ("Jill")
			create max.make ("Max")
			create feb17.make (02, 17) -- Feb 17
			create bb.make
			-- add birthdays for Jack and Jill
			bb.put (jack, [14,01])  -- Jan 14
			bb.put (jill, [17,02])  -- Feb 17

			create tuples.make
			across bb is x -- expected: each entry retrieved from the iterable BB is [BIRTHDAY, NAME]
			loop
				tuples.extend (x)
			end

			Result := tuples.count = 2
							and
							tuples[1].item (1) ~ create {BIRTHDAY}.make (01, 14)
							and
							tuples[1].item (2) ~ create {NAME}.make ("Jack")
							and
							tuples[1].bd ~ create {BIRTHDAY}.make (01, 14)
							and
							tuples[1].n ~ create {NAME}.make ("Jack")
		end

end
