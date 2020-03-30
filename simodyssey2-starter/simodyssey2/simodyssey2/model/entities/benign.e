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
			create death_msg.make_empty
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
				death_msg.append ("Benign got lost in space - out of fuel at Sector:" + location.out)
			elseif location.has_blackhole then
				life := 0
				death_msg.append ("Benign got devoured by blackhole (id: -1) at Sector:3:3")
			end

			if fuel = 0 and death_msg.is_empty then
				life := 0
				death_msg.append ("Benign got lost in space - out of fuel at Sector:" + location.out)
			end

		end

	reproduce: detachable ENTITY_MOVABLE
		local
			temp: BENIGN
		do
			if repro_interval = 0 then
				if not location.is_full then
					create temp.make (shared_info.movable_id, location)
					shared_info.inc_movable_id
					location.put (temp)
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
	behave
		local
			movables: SORTED_TWO_WAY_LIST[ENTITY_MOVABLE]
			msg: STRING
		do
			movables := location.get_movables
			create msg.make_empty
			across
				movables as entity
			loop
				if entity.item.is_malevolent then
					msg.append ("Malevolent got destroyed by benign (id: " + id.out)
					msg.append (") at Sector:" + location.print_sector)
					move_info.append ("%N   destroyed " + entity.item.id_out + " at " + entity.item.loc_out)
					entity.item.kill
					entity.item.set_death_msg (msg)
					location.remove (entity.item)
				end
				msg.wipe_out
			end
		end

	get_name: STRING
		do
			create Result.make_from_string ("Benign")
		end

end
