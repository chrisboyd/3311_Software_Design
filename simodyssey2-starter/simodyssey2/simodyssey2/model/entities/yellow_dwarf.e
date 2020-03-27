note
	description: "Summary description for {YELLOW_DWARF}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	YELLOW_DWARF

inherit
	STAR

create
	make

feature --Initialization
	make(i: INTEGER; loc: SECTOR)
		do
			item := 'Y'
			id := i
			luminosity := 2
			location := loc
		end

end
