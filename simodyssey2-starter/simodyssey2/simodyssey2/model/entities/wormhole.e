note
	description: "Wormhole allows instant travel between sectors without using fuel"
	author: "Chris Boyd : 216 869 356 : chris360"
	date: "$Date$"
	revision: "$Revision$"

class
	WORMHOLE

inherit
	ENTITY_STATIONARY

create
	make

feature --Initialization
	make(i: INTEGER; loc: SECTOR)
		do
			item := 'W'
			id := i
			location := loc
		end

invariant
    allowable_symbols:
        item = 'W'

end
