note
	description: "Star that provides 2 fuel and can support life"
	author: "Chris Boyd : 216 869 356 : chris360"
	date: "$Date$"
	revision: "$Revision$"

class
	YELLOW_DWARF

inherit

	STAR

create
	make

feature --Initialization

	make (i: INTEGER; loc: SECTOR)
		do
			item := 'Y'
			id := i
			luminosity := 2
			location := loc
		end

invariant
	allowable_symbols: item = 'Y'

end
