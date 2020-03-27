note
	description: "Summary description for {PLANET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLANET

inherit
	ENTITY_MOVABLE

create
	make

feature --Initialization
	make(i: INTEGER; loc: SECTOR)
		do
			item := 'P'
			id := i
			location := loc
		end

feature --Commands
	move(dest: SECTOR)
		do
		end

	check_post_move
		do
		end

	reproduce
		do
		end

	behave
		do
			--print("plane behave %N")
		end
end
