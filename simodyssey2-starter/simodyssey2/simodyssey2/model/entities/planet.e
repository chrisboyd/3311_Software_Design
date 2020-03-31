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
	has_set: BOOLEAN
	visited: BOOLEAN

feature --Initialization
	make(i: INTEGER; loc: SECTOR)
		do
			item := 'P'
			id := i
			location := loc
			life := 1
			create entity_msg.make_empty
			create move_info.make_empty
		end

feature --Commands

	move(dest: SECTOR)
		do
			move_info.wipe_out
			--remove from location, add to destination
			move_info.append ("    " + Current.id_out + ":" + Current.loc_out)
			if not dest.is_full then
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
				entity_msg.append ("Planet got devoured by blackhole (id: -1) at Sector:3:3")
				location.remove (Current)
			end
		end

	reproduce(next_id: INTEGER): detachable ENTITY_MOVABLE
		do
		end

	behave: LINKED_LIST [ENTITY_MOVABLE]
		local
			odds_life: INTEGER
		do
			create Result.make
			Result.compare_objects
			if location.has_star then
				orbiting := True
				if location.has_yellow_dwarf and not has_set then
					odds_life := gen.rchoose (1, 2)
					if odds_life = 2 then
						supports_life := True
					end
					has_set := True
				end
			else
				turns_left := gen.rchoose (0, 2)
			end
		end

	set_orbit
		do
			orbiting := True
		end

	set_life
		do
			supports_life := True
		end

	set_visited
		do
			visited := True
		end

feature --Queries

	get_name: STRING
		do
			create Result.make_from_string ("Planet")
		end

	get_status: STRING
		do
			create Result.make_empty
			Result.append ("    " + id_out + "->attached?:" + orbiting.out.at (1).out + ", support_life?:")
			Result.append (supports_life.out.at (1).out + ", visited?:" + visited.out.at (1).out)
			Result.append (", turns_left:")
			if orbiting or (life = 0) then
				Result.append("N/A")
			else
				Result.append (turns_left.out)
			end
		end

end
