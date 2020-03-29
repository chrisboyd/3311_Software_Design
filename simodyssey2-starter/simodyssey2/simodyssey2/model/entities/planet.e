note
	description: "Summary description for {PLANET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLANET

inherit
	ENTITY_MOVABLE
		redefine
			check_post_move
		end

create
	make

feature --Attributes
	orbiting: BOOLEAN
	supports_life: BOOLEAN

feature --Initialization
	make(i: INTEGER; loc: SECTOR)
		do
			item := 'P'
			id := i
			location := loc
			life := 1
			create death_msg.make_empty
		end

feature --Commands

	check_post_move
		do
			if location.has_blackhole then
				life := 0
			end
		end

	reproduce: detachable ENTITY_MOVABLE
		do
		end

	behave
		do
			--print("plane behave %N")
		end

	set_orbit
		do
			orbiting := True
		end

	set_life
		do
			supports_life := True
		end

	get_name: STRING
		do
			create Result.make_from_string ("Planet")
		end

end
