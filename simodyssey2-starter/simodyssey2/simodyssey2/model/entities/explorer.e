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
	found_life: BOOLEAN

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
			elseif landed then
				fuel := 3
				life := 3
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

	behave: LINKED_LIST [ENTITY_MOVABLE]
		do
			create Result.make
			Result.compare_objects
		end

	land: STRING
		local
			valid_planet: BOOLEAN
			movables: SORTED_TWO_WAY_LIST[ENTITY_MOVABLE]
		do
			create Result.make_empty
			movables := location.get_movables
			if not location.has_yellow_dwarf then
				Result.append ("Negative on that request:no yellow dwarf at Sector:")
				Result.append (location.out)
			elseif not location.has_planet then
				Result.append ("Negative on that request:no planets at Sector:")
				Result.append (location.out)
			else
				from
					movables.start
				until
					movables.after or landed
				loop
					if movables.item.is_planet then
						check attached {PLANET} movables.item as p then
							if p.orbiting then
								if not p.visited then
									p.set_visited
									valid_planet := True
									landed := True
								end
							end
						end
					end --if
					movables.forth
				end--loop

				if not landed then
					Result.append("Negative on that request:no unvisited attached planet at Sector:")
					Result.append (location.out)
				end
			end

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
