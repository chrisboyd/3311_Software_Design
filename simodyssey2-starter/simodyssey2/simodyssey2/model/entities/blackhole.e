note
	description: "Stationary entity that kills everything that enters the sector"
	author: "Chris Boyd : 216 869 356 : chris360"
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
			id := i
			item := 'O'
			location := loc
		end

invariant
    allowable_symbols:
		item = 'O'

end
