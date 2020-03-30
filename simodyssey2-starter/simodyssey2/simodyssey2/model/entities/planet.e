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
			move
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
			create move_info.make_empty
		end

feature --Commands

	move(dest: SECTOR)
		do
			move_info.wipe_out
			if not location.has_star then
				--remove from location, add to destination
				move_info.append ("    " + Current.id_out + ":" + Current.loc_out)
				dest.put (Current)
				location.remove (Current)
				location := dest
				move_info.append ("->" + Current.loc_out)
			end
		end

	check_post_move
		do
			if location.has_blackhole then
				life := 0
				death_msg.append ("Planet got devoured by blackhole (id: -1) at Sector:3:3")
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
