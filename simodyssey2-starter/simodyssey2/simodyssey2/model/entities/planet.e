note
	description: "Planets travel the galaxy seeking out stars to orbit"
	author: "Chris Boyd : 216 869 356 : chris360"
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
		--Redefine move for planets because once they enter an orbit, don't
		--move
		do
			move_info.wipe_out
			--remove from location, add to destination
			if not orbiting then
				move_info.append ("    " + Current.id_out + ":" + Current.loc_out)
				if not dest.is_full then
					dest.put (Current)
					location.remove (Current)
					location := dest
					move_info.append ("->" + Current.loc_out)
				end
			end

		end

	check_post_move
		--if planet moves into a sector with blackhole, dies
		do
			if location.has_blackhole then
				life := 0
				entity_msg.append ("Planet got devoured by blackhole (id: -1) at Sector:3:3")
				location.remove (Current)
			end
		end

	reproduce(next_id: INTEGER): detachable ENTITY_MOVABLE
		--planets don't reproduce
		do
		end

	behave: LINKED_LIST [ENTITY_MOVABLE]
		--If sector has a star, orbit it, if the star is a yellow dwarf
		--randomly assign if planet supports life (50% chance)
		--Once this value is set, it will not change
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
		--Planet is now orbiting a star
		do
			orbiting := True
		end

	set_life
		--planet supports life
		do
			supports_life := True
		end

	set_visited
		--planet has been visited by explorer
		do
			visited := True
		end

feature --Queries

	get_name: STRING
		--Return string represation of this class
		do
			create Result.make_from_string ("Planet")
		end

	get_status: STRING
		--Returns current status of the benign for
		--outputing in test mode
		--[id,P]->attached?:t|f, support_life?:t|f, visited?:t|f, turns_left:X
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

invariant
    allowable_symbols:
        item = 'P'

end
