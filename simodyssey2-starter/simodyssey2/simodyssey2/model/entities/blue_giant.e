note
	description: "Vibrant star that provides up to 5 units of fuel"
	author: "Chris Boyd : 216 869 356 : chris360"
	date: "$Date$"
	revision: "$Revision$"

class
	BLUE_GIANT

inherit
	STAR

create
	make

feature --Initialization
	make(i: INTEGER; loc: SECTOR)
		do
			item := '*'
			id := i
			luminosity := 5
			location := loc
		end

invariant
    allowable_symbols:
		item = '*'

end
