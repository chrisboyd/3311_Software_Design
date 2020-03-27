note
	description: "Summary description for {BLUE_GIANT}."
	author: ""
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

end
