note
	description: "Summary description for {JANITAUR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JANITAUR

inherit
	ENTITY_MOVABLE
		redefine
			check_post_move
		end

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
			create death_msg.make_empty
		end

feature --attributes
	repro_interval: INTEGER
	load_level: INTEGER
feature --Commands

	check_post_move
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
			elseif location.has_blackhole then
				life := 0
			end

			if fuel = 0 then
				life := 0
			end
		end

	reproduce: detachable ENTITY_MOVABLE
		do
			if repro_interval = 0 then
				if not location.is_full then
					Result := create {JANITAUR}.make (shared_info.movable_id, location)
					shared_info.inc_movable_id
					location.put (Result)
					repro_interval := 2
				end
			else
				repro_interval := repro_interval - 1
			end
		end

	--Janitaur grabs up to two asteroids in the current sector
	--taking them off the board until they can be dumped in a sector
	--with a wormhole, from which they do not return
	--Asteroid got imploded by janitaur (id: Z) at Sector:X:Y
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
				if load_level < 2 then
					if entity.item.is_asteroid then
						load_level := load_level + 1
						entity.item.kill
						msg.append ("Asteroid got imploded by janitaur (id: " + id.out)
						msg.append (") at Sector:" + location.print_sector)
						entity.item.set_death_msg (msg)
						location.remove (entity.item)
					end
				end
			end
			if location.has_wormhole then
				load_level := 0
			end

		end

	get_name: STRING
		do
			create Result.make_from_string ("Janitaur")
		end

end
