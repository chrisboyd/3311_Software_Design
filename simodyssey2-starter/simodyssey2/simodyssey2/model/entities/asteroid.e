note
	description: "Summary description for {ASTEROID}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ASTEROID

inherit
	ENTITY_MOVABLE

create
	make

feature --Initialization
	make(i: INTEGER; loc: SECTOR)
		do
			item := 'A'
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
		end

end
