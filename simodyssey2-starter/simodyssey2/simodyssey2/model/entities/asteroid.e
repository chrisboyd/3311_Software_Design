note
	description: "Summary description for {ASTEROID}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ASTEROID

inherit
	ENTITY_MOVABLE
		redefine
			check_post_move
		end

create
	make


feature --Initialization
	make(i: INTEGER; loc: SECTOR)
		do
			item := 'A'
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
		end

	get_name: STRING
		do
			create Result.make_from_string ("Asteroid")
		end

end
