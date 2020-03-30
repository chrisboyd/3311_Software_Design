note
	description: "Summary description for {ENTITY_STATIONARY}."
	author: ""
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

end
