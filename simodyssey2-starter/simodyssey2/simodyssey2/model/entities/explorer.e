note
	description: "Summary description for {EXPLORER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXPLORER

inherit
	ENTITY_MOVABLE

create
	make

feature -- Initialization

	make(i: INTEGER; loc: SECTOR)
			-- Initialization for `Current'.
		do
			item := 'E'
			id := i
			life := 3
			fuel := 3
			landed := False
			location := loc
			create death_msg.make_empty
			create move_info.make_empty
		end

feature --Attributes
	landed: BOOLEAN

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
				death_msg.append ("Explorer got lost in space - out of fuel at Sector:" + location.out)
			elseif location.has_blackhole then
				life := 0
				death_msg.append ("Explorer got devoured by blackhole (id: -1) at Sector:3:3")
			end

			if fuel = 0 and death_msg.is_empty then
				life := 0
				death_msg.append ("Explorer got lost in space - out of fuel at Sector:" + location.out)
			end

			if life = 0 then
				location.remove (Current)
			end

		end

	reproduce(next_id: INTEGER): detachable ENTITY_MOVABLE
		do
		end

	behave
		do
			--print("explorer behave %N")
		end

	land
		do
			landed := True
		end

	liftoff
		do
			landed := False
		end

feature --Queries

	get_name: STRING
		do
			create Result.make_from_string ("Explorer")
		end

	get_status: STRING
		do
			create Result.make_empty
			Result.append ("    " + id_out + "->fuel:" + fuel.out + "/3, life:" + life.out)
			Result.append ("/3, landed?:" + landed.out.at (1).out)
		end

end
