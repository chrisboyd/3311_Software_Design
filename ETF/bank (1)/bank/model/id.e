note
	description: "Summary description for {ID}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ID

create
	make

feature {NONE} -- Initialization

	make(i: ID)
			-- Initialization for `Current'.
		do
			id := i
		end
feature
	id: ID

end
