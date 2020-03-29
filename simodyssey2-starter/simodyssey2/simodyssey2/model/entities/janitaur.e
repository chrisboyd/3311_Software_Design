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
			repro_interval := 1
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

	reproduce
		do
		end

	behave
		do
		end

	get_name: STRING
		do
			create Result.make_from_string ("Janitaur")
		end

end
