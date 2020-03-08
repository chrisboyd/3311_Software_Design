note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	BANK

inherit
	ANY
		redefine
			out
		end

create {BANK_ACCESS}
	make

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		do
			s := "init"
			i := 1
			create accounts.make
			create error.make_empty
		end

feature -- model attributes
	s : STRING
	i : INTEGER

feature --implementation
	accounts: LINKED_LIST[ACCOUNT]
	error: STRING

feature -- model operations
--	default_update
--			-- Perform update to the model state.
--		do
--			i := i + 2
--		end

	set_error(msg: STRING)
		do
			error := msg
		end

	deposit(id: STRING; amount: INTEGER)
		do
--			s := "deposit"
--			i := i + 2
			across
				accounts as cursor
			loop
				if cursor.item.id ~ id then
					cursor.item.deposit (amount)
				end
			end
		end

	withdraw(id: STRING; amount: INTEGER)
		do
--			s := "withdraw"
--			i := i + 2
			across
				accounts as cursor
			loop
				if cursor.item.id ~ id then
					cursor.item.withdraw(amount)
				end
			end

		end

	transfer(id_from: STRING; id_to: STRING; amount: INTEGER)
		do
--			s := "transfer"
--			i := i + 2
			across
				accounts as cursor
			loop
				if cursor.item.id ~ id_from then
					cursor.item.withdraw (amount)
				elseif cursor.item.id ~ id_to then
					cursor.item.deposit (amount)
				end
			end
		end

	new (id: STRING)
		require
			non_existing_id:
				not (across
						accounts as cursor
					some
				 		cursor.item.id ~ id
					end)
		do
			s := "new"
			i := i + 2
			accounts.extend (create {ACCOUNT}.make (id))
		end

	reset
			-- Reset model state.
		do
			make
		end

feature -- queries
	out : STRING
		local
			j: INTEGER
		do

--			create Result.make_from_string ("  ")
--			Result.append ("State of Bank ")
--			Result.append ("[")
--			Result.append (i.out)
--			Result.append ("]")
--			Result.append (" after ")
--			Result.append (s)
			create Result.make_empty
			if error.is_empty then
				Result.append ("accounts: {")
				j := 1
				across
					accounts as cursor
				loop
					Result.append(cursor.item.out)
					if j < accounts.count then
						Result.append(", ")
					end

					j := j + 1
				end
				Result.append ("}")
			else
				Result.append ("  Error: ")
				Result.append (error)
			end
		end

end




