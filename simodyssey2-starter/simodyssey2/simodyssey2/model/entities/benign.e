note
	description: "Summary description for {BENIGN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BENIGN

inherit
	ENTITY_MOVABLE

create
	make

feature -- Initialization

	make(i: INTEGER; loc: SECTOR)
			-- Initialization for `Current'.
		do
			item := 'B'
			id := i
			fuel := 3
			repro_interval := 1
			location := loc
			life := 1
			create entity_msg.make_empty
			create move_info.make_empty
		end

feature --attributes
	repro_interval: INTEGER

feature --Commands
	check_post_move
		local
			stationary: ENTITY_STATIONARY
		do
			if location.has_star then
				stationary := location.get_stationary
				check attached {STAR} stationary as s then
					fuel := fuel + s.luminosity
					if fuel > 3 then
						fuel := 3
					end
				end
			--handle situation of out of fuel and in blackhole sector,
			--explorer dies by out of fuel first
			elseif fuel = 0 then
				life := 0
				entity_msg.append ("Benign got lost in space - out of fuel at Sector:" + location.out)
			elseif location.has_blackhole then
				life := 0
				entity_msg.append ("Benign got devoured by blackhole (id: -1) at Sector:3:3")
			end

			if fuel = 0 and entity_msg.is_empty then
				life := 0
				entity_msg.append ("Benign got lost in space - out of fuel at Sector:" + location.out)
			end

			if life = 0 then
				location.remove (Current)
			end

		end

	reproduce(next_id: INTEGER): detachable ENTITY_MOVABLE
		local
			temp: BENIGN
			turns : INTEGER
		do
			if repro_interval = 0 then
				if not location.is_full then
					create temp.make (next_id, location)
					location.put (temp)
					turns := gen.rchoose (0, 2)
					temp.set_turns (turns)
					repro_interval := 1
					move_info.append ("%N      reproduced " + temp.id_out + " at " + temp.loc_out)
					Result := temp
				end
			else
				repro_interval := repro_interval - 1
			end
		end

	--destroy all malevolent in sector from low to high id
	--Malevolent got destroyed by benign (id: Z) at Sector:X:Y
	behave: LINKED_LIST [ENTITY_MOVABLE]
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
				if entity.item.is_malevolent then
					msg.append ("Malevolent destroyed by benign (id: " + id.out)
					msg.append (") at Sector:" + location.print_sector)
					move_info.append ("%N      destroyed " + entity.item.id_out + " at " + entity.item.loc_out)
					entity.item.kill
					entity.item.set_entity_msg (msg)
					location.remove (entity.item)
					Result.extend (entity.item)
				end
				create msg.make_empty
			end
			turns_left := gen.rchoose (0, 2)
		end

feature --Queries

	get_name: STRING
		do
			create Result.make_from_string ("Benign")
		end

	get_status: STRING
		do
			create Result.make_empty
			Result.append ("    " + id_out + "->fuel:" + fuel.out + "/3, actions_left_until_reproduction:")
			Result.append (repro_interval.out + "/1, turns_left:")
			if life = 0 then
				Result.append("N/A")
			else
				Result.append(turns_left.out)
			end
		end

end
