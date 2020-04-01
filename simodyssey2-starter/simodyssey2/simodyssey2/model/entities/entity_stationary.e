note
	description: "Base class for stationary entites"
	author: "Chris Boyd : 216 869 356 : chris360"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ENTITY_STATIONARY

inherit
	ENTITY_ALPHABET

feature --Queries

	get_status: STRING
		do
			create Result.make_empty
			Result.append ("    [" + id.out + "," + item.out + "]->")
		end

invariant
    allowable_symbols:
        item = 'O' or item = 'W' or item = 'Y' or item = '*'

end
