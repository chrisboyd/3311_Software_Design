note
	description: "Summary description for {BLACKHOLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BLACKHOLE

inherit
	ENTITY_STATIONARY

create
	make

feature --Initialization
	make(i: INTEGER; loc: SECTOR)
		do
			item := 'O'
			location := loc
		end

end
