note
	description: "Intrepid explorer that travels the galaxy seeking new life"
	author: "Chris Boyd : 216 869 356 : chris360"
	date: "$Date$"
	revision: "$Revision$"

class
	EXPLORER

inherit

	ENTITY_MOVABLE

create
	make

feature -- Initialization

	make (i: INTEGER; loc: SECTOR)
			-- Initialization for `Current'.
		do
			item := 'E'
			id := i
			life := 3
			fuel := 3
			landed := False
			location := loc
			create entity_msg.make_empty
			create move_info.make_empty
		end

feature --Attributes

	landed: BOOLEAN
			--is the explorer landed on a planet

	found_life: BOOLEAN
			--did the explorer find life on a planet after landing

feature --Commands

	check_post_move
			--Checks if explorers new location contains a blackhole, which will
			--kill the explorer, checks for a star to refuel, if life or fuel
			--reach 0, dies
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
				entity_msg.append ("Explorer got lost in space - out of fuel at Sector:" + location.out)
			elseif location.has_blackhole then
				life := 0
				entity_msg.append ("Explorer got devoured by blackhole (id: -1) at Sector:3:3")
			end
			if fuel = 0 and entity_msg.is_empty then
				life := 0
				entity_msg.append ("Explorer got lost in space - out of fuel at Sector:" + location.out)
			end
			if life = 0 then
				location.remove (Current)
			end
		end

	reproduce (next_id: INTEGER): detachable ENTITY_MOVABLE
			--Explorer does not reproduce, sad explorer
		do
		end

	behave: LINKED_LIST [ENTITY_MOVABLE]
			--Explorer does not behave without user input
		do
			create Result.make
			Result.compare_objects
		end

	land: STRING
			--Attemp to land on an unvisited planet in the sector to seek out life
			--must be a yellow star in the sector
			--Can attempt to land during successive turns on each planet in current sector
			--until all are visited
			--Cannot move again until the explorer lifts off
		require
			not_landed: not landed
		local
			valid_planet: BOOLEAN
			movables: SORTED_TWO_WAY_LIST [ENTITY_MOVABLE]
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
										--Game will be over, found a planet to support life
									if p.supports_life then
										found_life := True
										entity_msg.append ("Tranquility base here - we've got a life!")
											--Planet does not support life, heal and refuel
									else
										found_life := False
										entity_msg.append ("Explorer found no life as we know it at Sector:" + location.out)
										fuel := 3
										life := 3
									end
								end
							end
						end
					end --if
					movables.forth
				end --loop

				if not landed then
					Result.append ("Negative on that request:no unvisited attached planet at Sector:")
					Result.append (location.out)
				end
			end
		end

	liftoff
			--Explorer leaves the planet for new adventures
		require
			landed: landed
		do
			landed := False
			entity_msg.append ("Explorer has lifted off from planet at Sector:" + location.out)
		end

feature --Queries

	get_name: STRING
			--Return string represation of this class
		do
			create Result.make_from_string ("Explorer")
		end

	get_status: STRING
			--Returns current status of the benign for
			--outputing in test mode
			--[id,E]->fuel:F/3, life:L/3, landed?:t|f
		do
			create Result.make_empty
			Result.append ("    " + id_out + "->fuel:" + fuel.out + "/3, life:" + life.out)
			Result.append ("/3, landed?:" + landed.out.at (1).out)
		end

invariant
	allowable_symbols: item = 'E'

end
