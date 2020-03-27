note
	description: "Summary description for {YELLOW_DWARF}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	YELLOW_DWARF

inherit
	STAR
		redefine
            out
        end

create
	make

feature --Initialization
	make(i: INTEGER)
		do
			item := 'Y'
			id := i
			luminosity := 2
		end

feature --Queries
	out: STRING
		do
			Result := item.out
		end

end
