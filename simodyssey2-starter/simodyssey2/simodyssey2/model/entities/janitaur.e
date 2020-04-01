note
	description: "Entity that seeks out and destroys asteroids"
	author: "Chris Boyd : 216 869 356 : chris360"
	date: "$Date$"
	revision: "$Revision$"

class
	JANITAUR

inherit
	ENTITY_MOVABLE

create
	make

feature -- Initialization

	make(i: INTEGER; loc: SECTOR)
			-- Initialization for `Current'.
		do
			item := 'J'
			id := i
			fuel := 5
			repro_interval := 2
			location := loc
			life := 1
			load_level := 0
			create entity_msg.make_empty
			create move_info.make_empty
		end

feature --attributes
	repro_interval: INTEGER
	load_level: INTEGER
feature --Commands

	check_post_move
		--Check for a star to refuel at, if run out of fuel or enter
		--sector with a blackhole, dies
		local
			stationary: ENTITY_STATIONARY
		do
			if location.has_star then
				stationary := location.get_stationary
				check attached {STAR} stationary as s then
					fuel := fuel + s.luminosity
					if fuel > 5 then
						fuel := 5
					end
				end
			--handle situation of out of fuel and in blackhole sector,
			-- dies by out of fuel first
			elseif fuel = 0 then
				life := 0
				entity_msg.append ("Janitaur got lost in space - out of fuel at Sector:" + location.out)
			elseif location.has_blackhole then
				life := 0
				entity_msg.append ("Janitaur got devoured by blackhole (id: -1) at Sector:3:3")
			end

			if fuel = 0 and entity_msg.is_empty then
				life := 0
				entity_msg.append ("Janitaur got lost in space - out of fuel at Sector:" + location.out)
			end

			if life = 0 then
				location.remove (Current)
			end
		end

	reproduce(next_id: INTEGER): detachable ENTITY_MOVABLE
		--if reproduce timer is up, create a new janitaur in
		--current location (if not full)
		local
			temp: JANITAUR
			turns: INTEGER
		do
			if repro_interval = 0 then
				if not location.is_full then
					create temp.make (next_id, location)
					location.put (temp)
					turns := gen.rchoose (0, 2)
					temp.set_turns (turns)
					move_info.append ("%N      reproduced " + temp.id_out + " at " + temp.loc_out)
					repro_interval := 2
					Result := temp
				end
			else
				repro_interval := repro_interval - 1
			end
		end


	behave: LINKED_LIST [ENTITY_MOVABLE]
		--Janitaur grabs up to two asteroids in the current sector
		--taking them off the board until they can be dumped in a sector
		--with a wormhole, from which they do not return
		--Asteroid got imploded by janitaur (id: Z) at Sector:X:Y
		local
			movables: SORTED_TWO_WAY_LIST[ENTITY_MOVABLE]
			msg: STRING
		do
			create Result.make
			Result.compare_objects
			movables := location.get_movables
			create msg.make_empty
			across
				movables as entity
			loop
				if load_level < 2 then
					if entity.item.is_asteroid then
						load_level := load_level + 1
						entity.item.kill
						msg.append ("Asteroid got imploded by janitaur (id: " + id.out)
						msg.append (") at Sector:" + location.print_sector)
						move_info.append ("%N      destroyed "+ entity.item.id_out + " at " + entity.item.loc_out)
						entity.item.set_entity_msg (msg)
						location.remove (entity.item)
						Result.extend (entity.item)
					end
				end
				create msg.make_empty
			end
			if location.has_wormhole then
				load_level := 0
			end
			turns_left := gen.rchoose (0, 2)
		end

feature --Queries

	get_name: STRING
		--Return string represation of this class
		do
			create Result.make_from_string ("Janitaur")
		end

	get_status: STRING
		--Returns current status of the benign for
		--outputing in test mode
		--[id,J]->fuel:fF/3, actions_left_until_reproduction:A/2, turns_left:X
		do
			create Result.make_empty
			Result.append ("    " + id_out + "->fuel:" + fuel.out + "/5, load:" + load_level.out)
			Result.append ("/2, actions_left_until_reproduction:" + repro_interval.out + "/2, turns_left:")
			if life = 0 then
				Result.append("N/A")
			else
				Result.append(turns_left.out)
			end
		end

invariant
    allowable_symbols:
        item = 'J'

end
