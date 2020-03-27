note
	description: "Summary description for {BLACKHOLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BLACKHOLE

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
			item := 'O'
		end

feature --Queries
	out: STRING
		do
			Result := item.out
		end

end
