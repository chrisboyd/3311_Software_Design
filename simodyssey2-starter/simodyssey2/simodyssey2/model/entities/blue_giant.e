note
	description: "Summary description for {BLUE_GIANT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BLUE_GIANT

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
			item := '*'
			id := i
			luminosity := 5
		end

feature --Queries
	out: STRING
		do
			Result := item.out
		end

end
