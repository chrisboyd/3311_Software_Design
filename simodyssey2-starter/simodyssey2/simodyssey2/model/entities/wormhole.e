note
	description: "Summary description for {WORMHOLE}."
	author: ""
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

end
