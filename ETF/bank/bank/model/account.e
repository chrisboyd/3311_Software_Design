note
	description: "Summary description for {ACCOUNT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ACCOUNT
inherit
	ANY
		redefine
			out
		end

create
	make

feature -- commands
	make(new_id: STRING)
		do
			id := new_id
			balance := 0
		end

	deposit(amount: INTEGER)
		do
			balance := balance + amount
		end

	withdraw(amount: INTEGER)
		do
			balance := balance - amount
		end

feature --attributes
	id: STRING
	balance: INTEGER

feature --output
	out: STRING
		do
			Result := "Account with id " + id + " has balance " + balance.out
		end

invariant
	balance >= 0

end
