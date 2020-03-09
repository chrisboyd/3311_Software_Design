note
	description: "Summary description for {ACCOUNT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ACCOUNT

create
	make

feature {NONE} -- Initialization

	make(i: ID)
		do
			id := i
		end

feature
	id: ID

end
