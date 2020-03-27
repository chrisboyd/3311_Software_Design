note
	description: "Summary description for {WORMHOLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WORMHOLE

inherit
	ENTITY_STATIONARY
		redefine
            out
        end

create
	make

feature --Initialization
	make(i: INTEGER)
		do
			item := 'W'
		end

feature --Queries
	out: STRING
		do
			Result := item.out
		end

end
