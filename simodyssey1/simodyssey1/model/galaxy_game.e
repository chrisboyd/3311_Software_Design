note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	GALAXY_GAME

inherit
	ANY
		redefine
			out
		end

create {GALAXY_GAME_ACCESS}
	make

feature {NONE} -- model attributes

	state : INTEGER			--valid states game has gone through
	error_state : INTEGER		--error states game has encountered
	fuel_msg : STRING
	blackhole_msg: STRING
	planet_msg: STRING
	land_msg: STRING
	liftoff_msg: STRING
	status_msg: STRING
	abort_msg: STRING
	movement: STRING
	in_play: BOOLEAN			--is there a game currently active
	error : STRING			--error message to output to player
	test_mode : BOOLEAN		-- is the game in test mode
	grid: ARRAY2 [SECTOR] 	-- the board
	movable_entities: SORTED_TWO_WAY_LIST[ENTITY_MOVABLE]
	stationary_entities: SORTED_TWO_WAY_LIST[ENTITY_STATIONARY]
	explorer : ENTITY_MOVABLE
	deaths: QUEUE[PAIR[ENTITY_MOVABLE, STRING]]

	gen: RANDOM_GENERATOR_ACCESS

	shared_info_access : SHARED_INFORMATION_ACCESS

	shared_info: SHARED_INFORMATION
		attribute
			Result:= shared_info_access.shared_info
		end

feature {NONE} -- Initialization
	make (s: INTEGER; e: INTEGER)
			-- Initialization for `Current'.
		local
				row : INTEGER
				column : INTEGER
				blackhole: ENTITY_STATIONARY
		do

			create movable_entities.make
			movable_entities.compare_objects
			create stationary_entities.make
			stationary_entities.compare_objects
			create explorer.make ('E', 0)
			create blackhole.make ('O', -1)

			movable_entities.extend (explorer)
			stationary_entities.extend (blackhole)

			state := s
			error_state := e
			in_play := FALSE
			test_mode := FALSE
			create error.make_empty
			create fuel_msg.make_empty
			create blackhole_msg.make_empty
			create land_msg.make_empty
			create status_msg.make_empty
			create liftoff_msg.make_empty
			create movement.make_empty
			create planet_msg.make_empty
			create abort_msg.make_empty
			create deaths.make_empty

			create grid.make_filled (create {SECTOR}.make_dummy, shared_info.number_rows, shared_info.number_columns)
			from
				row := 1
			until
				row > shared_info.number_rows
			loop

				from
					column := 1
				until
					column > shared_info.number_columns
				loop
					grid[row,column] := create {SECTOR}.make(row,column,explorer,blackhole)
					column:= column + 1;
				end
				row := row + 1
			end


		end


feature -- model operations
	default_update
			-- Perform update to the model state.
		do
			state := state + 1
		end

	reset
			-- Reset model state.
		do
			make (state, 0)
		end

	play
		do
			state := state + 1
			set_movable_items (30)
			set_stationary_items
			in_play := TRUE

		end

	test (p_threshold : INTEGER)
		do
			state := state + 1
			set_movable_items (p_threshold)
			set_stationary_items
			in_play := TRUE
			test_mode := TRUE

		end

	status
		local
			location: STRING
		do
			create location.make_empty
			location.append ("[" + explorer.row.out + ",")
			location.append (explorer.col.out + ",")
			location.append (grid[explorer.row, explorer.col].contents.index_of (explorer, 1).out + "]")
			if not in_play then
				error_state := error_state + 1
				error.append ("  Negative on that request:no mission in progress.")
			else
				if not explorer.is_landed then
					status_msg.append ("  Explorer status report:Travelling at cruise speed at " + location)
					status_msg.append ("%N  Life units left:3, Fuel units left:" + explorer.get_fuel.out)
				else
					status_msg.append ("  Explorer status report:Stationary on planet surface at " + location)
					status_msg.append ("%N  Life units left:3, Fuel units left:3")
				end
			end
		end

	is_playing : BOOLEAN
		do
			Result := in_play
		end

	set_error (msg : STRING)
		do
			error := msg
			error_state := error_state + 1
		end

	move (row_inc: INTEGER; col_inc: INTEGER)
		local
			coord: PAIR[INTEGER, INTEGER]
			sect: SECTOR
			stationary: ENTITY_ALPHABET
			i_replace: INTEGER

		do
			if not in_play then
				error_state := error_state + 1
				error.append ("  Negative on that request:no mission in progress.")
				error.append ("%N")
			else
				--get new coordinates to move explorer too
				coord := get_new_coord(explorer.get_location, [row_inc, col_inc])

				--make sure explorer isn't landed
				if movable_entities.first.is_landed then
					error_state := error_state + 1
					error.append ("  Negative on that request:you are currently landed at Sector:")
					error.append (grid[explorer.row, explorer.col].print_sector)
					error.append ("%N")

				--make sure sector isn't full
				elseif grid[coord.first, coord.second].is_full then
					error_state := error_state + 1
					error.append ("  Cannot transfer to new location as it is full.")
					error.append ("%N")
				--perform move
				else
					create deaths.make_empty
					state := state + 1
					explorer.use_fuel
					sect := grid[explorer.row, explorer.col]
					movement.wipe_out
					movement.append ("    [" + explorer.id.out + "," + "E]:")
					movement.append (out_coord_quad (explorer))
					movement.append ("->")

					i_replace := sect.contents.index_of (explorer, 1)
					sect.contents[i_replace] := Void
					explorer.set_location (coord.first, coord.second)
					--update sector to explorer's new position
					sect := grid[explorer.row, explorer.col]
					grid[coord.first, coord.second].put (explorer)
					movement.append (out_coord_quad (explorer))


					--check if explorer is out of fuel, and thus, dead					
					if explorer.fuel_empty then
						fuel_msg.wipe_out

						i_replace := sect.contents.index_of (explorer, 1)
						sect.contents[i_replace] := Void
						fuel_msg.append ("  Explorer got lost in space - out of fuel at Sector:")
						fuel_msg.append (grid[explorer.row, explorer.col].print_sector)
						deaths.enqueue (create {PAIR[ENTITY_MOVABLE,STRING]}.make (explorer, create {STRING}.make_from_string (fuel_msg)) )
						movable_entities.prune_all (explorer)
					end

					--check if there are stationary entities in sector
					--check if it is star to refuel or blackhole and explorer dies
					if grid[coord.first, coord.second].has_stationary then
						stationary := grid[coord.first, coord.second].get_stationary
						if stationary.is_blue_giant then
							explorer.add_fuel (5)
						elseif stationary.is_yellow_dwarf then
							explorer.add_fuel (2)
						elseif stationary.is_blackhole then
							blackhole_msg.wipe_out
							blackhole_msg.append ("  Explorer got devoured by blackhole (id: -1) at Sector:3:3")
							deaths.enqueue (create {PAIR[ENTITY_MOVABLE,STRING]}.make (explorer, create {STRING}.make_from_string (blackhole_msg)) )
--							grid[coord.first, coord.second].contents.prune_all (explorer)
							i_replace := sect.contents.index_of (explorer, 1)
							sect.contents[i_replace] := Void
							movable_entities.prune_all (explorer)
						end
					end
					update_movables
				end--end of landed if

			end -- end of in_play if
		end

	wormhole
		local
			temp_row: INTEGER
			temp_col: INTEGER
			added: BOOLEAN
			sect: SECTOR
			i_replace: INTEGER
		do
			if not in_play then
				error.append ("  Negative on that request:no mission in progress.")
				error_state := error_state + 1
			elseif explorer.is_landed then
				error.append ("  Negative on that request:you are currently landed at Sector:")
				error.append (grid[explorer.row, explorer.col].print_sector)
				error_state := error_state + 1
			elseif not grid[explorer.row, explorer.col].has_wormhole then
				error.append ("  Explorer couldn't find wormhole at Sector:")
				error.append (grid[explorer.row, explorer.col].print_sector)
				error_state := error_state + 1
			else
				state := state + 1
				from
					added := False
				until
					added
				loop
					temp_row := gen.rchoose (1, shared_info.number_rows)
					temp_col := gen.rchoose (1, shared_info.number_columns)

					if not grid[temp_row, temp_col].is_full then
						sect := grid[explorer.row, explorer.col]
						movement.wipe_out
						movement.append ("    [" + explorer.id.out + "," + "E]:")
						movement.append (out_coord_quad (explorer))
						movement.append ("->")

--						sect.contents.prune_all (explorer)
						i_replace := sect.contents.index_of (explorer, 1)
						sect.contents[i_replace] := Void
						explorer.set_location (temp_row, temp_col)
						grid[temp_row, temp_col].put (explorer)
						movement.append (out_coord_quad (explorer))

						added := True
					end
				end--end loop finding rand location until spot available
				update_movables
			end --end of use wormhole
		end

	land
		local
			planets: SORTED_TWO_WAY_LIST[ENTITY_MOVABLE]
			landed: BOOLEAN
		do
			if not in_play then
				error.append ("  Negative on that request:no mission in progress.")
				error_state := error_state + 1
			elseif explorer.is_landed then
				error.append ("  Negative on that request:already landed on a planet at Sector:")
				error.append (grid[explorer.row, explorer.col].print_sector)
				error_state := error_state + 1
			elseif not grid[explorer.row, explorer.col].has_yellow_dwarf then
				error.append ("  Negative on that request:no yellow dwarf at Sector:")
				error.append (grid[explorer.row, explorer.col].print_sector)
				error_state := error_state + 1
			elseif not grid[explorer.row, explorer.col].has_planet then
				error.append ("  Negative on that request:no planets at Sector:")
				error.append (grid[explorer.row, explorer.col].print_sector)
				error_state := error_state + 1
			else
				--check for unvisited planets, if found land
				planets := grid[explorer.row, explorer.col].get_planets
				across
					planets as p
				loop
					if not p.item.is_visited then
						state := state + 1
						landed := True
						p.item.visit
						explorer.set_land(True)
						if p.item.can_support_life then
							in_play := False
							land_msg.wipe_out
							land_msg.append ("  Tranquility base here - we've got a life!")
						else
							land_msg.wipe_out
							land_msg.append ("  Explorer found no life as we know it at Sector:")
							land_msg.append (grid[explorer.row, explorer.col].print_sector)
						end

						update_movables
					end
				end

				if not landed then
					error.append ("  Negative on that request:no unvisited attached planet at Sector:")
					error.append (grid[explorer.row, explorer.col].print_sector)
					error_state := error_state + 1
				end

			end --end of find unvisited planet and land
		end
	liftoff
		do
			if not in_play then
				error.append ("  Negative on that request:no mission in progress.")
				error_state := error_state + 1
			elseif not explorer.is_landed then
				error.append ("  Negative on that request:you are not on a planet at Sector:")
				error.append (grid[explorer.row, explorer.col].print_sector)
				error_state := error_state + 1
			else
				state := state + 1
				explorer.set_land (False)
				liftoff_msg.wipe_out
				liftoff_msg.append ("  Explorer has lifted off from planet at Sector:")
				liftoff_msg.append (grid[explorer.row, explorer.col].print_sector)
			end
		end

	pass
		do
			if not in_play then
				error.append ("  Negative on that request:no mission in progress.")
				error_state := error_state + 1
			else
				state := state + 1
				update_movables
			end
		end

	abort
		do
			error_state := error_state + 1
			if not in_play then
				error.append ("  Negative on that request:no mission in progress.")
			else
				abort_msg.append ("  Mission aborted.")
			end

		end

feature {NONE} --commands (internal)

	update_movables
		local
			row: INTEGER
			col: INTEGER
			i_replace: INTEGER
			life: INTEGER
			turns: INTEGER
		do
			across
				movable_entities as ent
			loop
				if not ent.item.is_explorer then
					row := ent.item.row
					col := ent.item.col
					if ent.item.get_turns = 0 then
						if ent.item.is_planet and grid[row,col].has_star then
							ent.item.attach_star
							if not ent.item.has_set_life then
								if  grid[row,col].has_yellow_dwarf then
									if gen.rchoose (1, 2) = 2 then
										ent.item.set_support_life (True)
									else
										ent.item.set_support_life (False)
									end
								end
							end

						else
							move_planet(ent.item)
							--check if it moved to a blackhole spot
							if grid[ent.item.row, ent.item.col].has_blackhole then
								i_replace := grid[ent.item.row, ent.item.col].contents.index_of (ent.item, 1)
								grid[ent.item.row, ent.item.col].contents[i_replace] := Void
								movable_entities.prune_all (ent.item)
								if planet_msg.is_empty then
									planet_msg.append ("  Planet got devoured by blackhole (id: -1) at Sector:3:3")
									deaths.enqueue (create {PAIR[ENTITY_MOVABLE,STRING]}.make (ent.item, create {STRING}.make_from_string (planet_msg)) )
								end
							elseif ent.item.is_planet then
								if  grid[row,col].has_star then
									ent.item.attach_star
									if not ent.item.has_set_life then
										if  grid[row,col].has_yellow_dwarf then
											if gen.rchoose (1, 2) = 2 then
												ent.item.set_support_life (True)
											else
												ent.item.set_support_life (False)
											end
										end
									end
								else
									turns := gen.rchoose (0, 2)
									ent.item.set_turn (turns)
								end
							end
						end
					else
						turns := ent.item.get_turns - 1
						ent.item.set_turn (turns)
					end
				end
			end
		end

	move_planet(planet: ENTITY_MOVABLE)
		local
			direction: INTEGER
			start: PAIR[INTEGER, INTEGER]
			dest: PAIR[INTEGER, INTEGER]
			inc: PAIR[INTEGER, INTEGER]
			i_replace: INTEGER
		do
			create start.make (planet.row, planet.col)
			direction := gen.rchoose (1, 8)

			inspect direction
			when 1 then --N
				create inc.make (-1, 0)
			when 2 then --NE
				create inc.make (-1, 1)
			when 3 then --E
				create inc.make (0, 1)
			when 4 then --SE
				create inc.make (1, 1)
			when 5 then --S
				create inc.make (1, 0)
			when 6 then --SW
				create inc.make (1, -1)
			when 7 then --W
				create inc.make (0, -1)
			when 8 then --NW
				create inc.make (-1, -1)
			else
				create inc.make (0, 0)
			end -- inspect

			dest := get_new_coord(start, inc)

			movement.append ("%N    [" + planet.id.out + ",P]:")
			movement.append (out_coord_quad(planet))

			if not grid[dest.first, dest.second].is_full then
				i_replace := grid[start.first, start.second].contents.index_of (planet, 1)
				grid[start.first, start.second].contents[i_replace] := Void
				planet.set_location (dest.first, dest.second)
				grid[dest.first, dest.second].put (planet)
				movement.append ("->")
				movement.append (out_coord_quad(planet))
			end
		end

	get_new_coord(start: PAIR[INTEGER,INTEGER]; increment: PAIR[INTEGER, INTEGER]): PAIR[INTEGER, INTEGER]
		local
			row_dest: INTEGER
			col_dest: INTEGER

		do
			if (start.first + increment.first) <= shared_info.number_rows then
				if (start.first + increment.first) >= 1 then
					row_dest := start.first + increment.first
				else
					row_dest := shared_info.number_rows
				end
			else
				row_dest := 1
			end

			if (start.second + increment.second) <= shared_info.number_columns then
				if (start.second + increment.second) >= 1 then
					col_dest := start.second + increment.second
				else
					col_dest := shared_info.number_columns
				end
			else
				col_dest := 1
			end

			Result := create {PAIR[INTEGER, INTEGER]}.make (row_dest, col_dest)
		end

	next_available_quad (sect: SECTOR)  : INTEGER
		require
			not sect.is_full
		local
			loop_counter : INTEGER
			occupant : ENTITY_ALPHABET
			empty_space_found : BOOLEAN
		do
			empty_space_found := FALSE
			from
				loop_counter := 1
			until
				loop_counter > sect.contents.count or empty_space_found
			loop
				occupant := sect.contents [loop_counter]
				if not attached occupant  then
					empty_space_found := TRUE
				else
					loop_counter := loop_counter + 1
				end
			end
			Result := loop_counter

		end

	has_stationary (sect: SECTOR) : BOOLEAN
		local
			stationary : BOOLEAN
		do

			stationary := FALSE
			across
				sect.contents is quad
			loop
				if attached quad as q then
					if q.is_stationary then
						stationary := TRUE
					end
				end

			end

			Result := stationary
		end


	set_movable_items (p_threshold : INTEGER)
		local
			threshold: INTEGER
			number_items: INTEGER
			loop_counter: INTEGER
			component: ENTITY_MOVABLE
			id: INTEGER
		do

			id := 1 --since Explorer id := 1
			across
				grid as sector
			loop
				if (sector.item.row = 3) and (sector.item.column = 3) then
				else
					number_items := gen.rchoose (1, shared_info.max_capacity - 1)
					from
						loop_counter := 1
					until
						loop_counter > number_items
					loop
						threshold := gen.rchoose (1, 100)

						if threshold < p_threshold then
							create component.make('P', id)
							component.set_location (sector.item.row, sector.item.column)
							component.set_turn (gen.rchoose (0, 2))
							movable_entities.extend (component)
							sector.item.put (component)
							id := id + 1
						end
						loop_counter := loop_counter + 1
					end--end loop_counter
				end--end check for sector 3 if-else
			end--end across loop
		end

	set_stationary_items
			-- distribute stationary items amongst the sectors in the grid.
			-- There can be only one stationary item in a sector
		local
			loop_counter: INTEGER
			check_sector: SECTOR
			temp_row: INTEGER
			temp_column: INTEGER
			id: INTEGER
			entity: ENTITY_STATIONARY
		do
			id := -2
			from
				loop_counter := 1
			until
				loop_counter > shared_info.number_of_stationary_items
			loop

				temp_row :=  gen.rchoose (1, shared_info.number_rows)
				temp_column := gen.rchoose (1, shared_info.number_columns)
				check_sector := grid[temp_row,temp_column]
				if (not check_sector.has_stationary) and (not check_sector.is_full) then
					--use temp entity to for create and add to grid
					entity := create_stationary_item(id)
					entity.set_location (temp_row, temp_column)
					grid[temp_row,temp_column].put (entity)
					loop_counter := loop_counter + 1
					id := id - 1
				end -- if
			end -- loop
		end -- feature set_stationary_items

	create_stationary_item(id : INTEGER): ENTITY_STATIONARY
			-- this feature randomly creates one of the possible types of stationary actors
		local
			chance: INTEGER
			stationary : ENTITY_STATIONARY
		do
			chance := gen.rchoose (1, 3)
			inspect chance
			when 1 then
				create stationary.make ('Y',id)
				stationary.set_luminosity (2)
			when 2 then
				create stationary.make('*',id)
				stationary.set_luminosity (5)
			when 3 then
				create stationary.make('W',id)
			else
				create stationary.make('Y',id) -- create more yellow dwarfs this will never happen, but create by default
				stationary.set_luminosity (2)
			end -- inspect
			stationary_entities.extend (stationary)
			Result := stationary
		end

--	return_m_ent_low_high (sect: SECTOR) : SEQ[ENTITY_ALPHABET]
--		local
--			temp: SEQ[ENTITY_ALPHABET]
--			i: INTEGER
--			inserted : BOOLEAN
--		do
--			create temp.make_empty

--			across
--				sect.contents is ent
--			loop
--				if ent.is_movable then
--					if temp.is_empty then
--						temp.append (ent)
--					else
--						from
--							i := temp.lower
--						until
--							i > temp.upper or inserted
--						loop
--							if ent.id <= temp[i].id then
--								temp.insert (ent, i)
--								inserted := True
--							end
--							i := i + 1
--						end--insert current movable entity into temp in order of id
--						if not inserted then
--							temp.append (ent)
--						end
--					end--temp was empty, inserted current movable into front of temp
--				end--current entity wasn't movable
--			end--end of across entities of sect

--			Result := temp
--		end

	out_coord_quad (ent: ENTITY_MOVABLE): STRING
		do
			create Result.make_empty
			Result.append ("[")
			Result.append_integer (ent.row)
			Result.append (",")
			Result.append_integer (ent.col)
			Result.append (",")
			Result.append_integer (grid[ent.row,ent.col].contents.index_of (ent, 1))
			Result.append ("]")
		end


	galaxy_out : STRING
		local
			string1: STRING
			string2: STRING
			row_counter: INTEGER
			column_counter: INTEGER
			contents_counter: INTEGER
			temp_sector: SECTOR
			temp_component: ENTITY_ALPHABET
			printed_symbols_counter: INTEGER
		do
			create Result.make_empty
			create string1.make(7*shared_info.number_rows)
			create string2.make(7*shared_info.number_columns)
			string1.append("%N")

			from
				row_counter := 1
			until
				row_counter > shared_info.number_rows
			loop
				string1.append("    ")
				string2.append("    ")

				from
					column_counter := 1
				until
					column_counter > shared_info.number_columns
				loop
					temp_sector:= grid[row_counter, column_counter]
				    string1.append("(")
	            	string1.append(temp_sector.print_sector)
	                string1.append(")")
				    string1.append("  ")
					from
						contents_counter := 1
						printed_symbols_counter:=0
					until
						contents_counter > temp_sector.contents.count
					loop
						temp_component := temp_sector.contents[contents_counter]
						if attached temp_component as character then
							string2.append_character(character.item)
						else
							string2.append("-")
						end -- if
						printed_symbols_counter:=printed_symbols_counter+1
						contents_counter := contents_counter + 1
					end -- loop

					from
					until (shared_info.max_capacity - printed_symbols_counter)=0
					loop
							string2.append("-")
							printed_symbols_counter:=printed_symbols_counter+1

					end
					string2.append("   ")
					column_counter := column_counter + 1
				end -- loop
				string1.append("%N")
				if not (row_counter = shared_info.number_rows) then
					string2.append("%N")
				end
				Result.append (string1.twin)
				Result.append (string2.twin)

				row_counter := row_counter + 1
				string1.wipe_out
				string2.wipe_out
			end
		end

	sectors_out: STRING
		local
			component: ENTITY_ALPHABET
			printed_symbols: INTEGER
		do

			create Result.make_empty
			across
				grid as sector
			loop
				printed_symbols := 0
				Result.append ("    [" + sector.item.row.out + "," + sector.item.column.out + "]->")

				across
					sector.item.contents as quadrant
				loop
					component := quadrant.item

					if attached component as entity then
						Result.append ("[" + entity.id.out + "," + entity.item.out + "]")
					else
						Result.append("-")
					end
					if not quadrant.after then
							Result.append(",")
					end
					printed_symbols := printed_symbols + 1
				end
				from
				until (shared_info.max_capacity - printed_symbols)=0
				loop
						Result.append("-")
						printed_symbols:=printed_symbols+1
						if (shared_info.max_capacity - printed_symbols)/=0 then
							Result.append (",")
						end

				end
				if not sector.after then
					Result.append ("%N")
				end

			end
		end

	entities_out: STRING
		local
			bool: STRING
		do
			create Result.make_empty
			create bool.make_empty
			across
				stationary_entities as s
			loop
				Result.append ("    [" + s.item.id.out + "," + s.item.item.out + "]->")
				if s.item.item = '*' or s.item.item = 'Y' then
					Result.append("Luminosity:" + s.item.get_luminosity.out)
				end

				Result.append ("%N")
			end

			across
				movable_entities as m
			loop
				Result.append ("    [" + m.item.id.out + "," + m.item.item.out + "]->")
				if m.item.item = 'E' then
					Result.append("fuel:" + m.item.get_fuel.out + "/3, life:3/3, ")
					Result.append ("landed?:" + m.item.is_landed.out.at (1).out)
				else
					Result.append ("attached?:" + m.item.is_attached.out.at (1).out + ", ")
					Result.append ("support_life?:" + m.item.can_support_life.out.at (1).out + ", ")
					Result.append ("visited?:" + m.item.is_visited.out.at (1).out + ", ")
					if m.item.is_attached  then
						Result.append ("turns_left:N/A")
					else
						Result.append ("turns_left:" + m.item.get_turns.out)
					end
				end
				if not m.after then
					Result.append ("%N")
				end

			end
		end

	deaths_out: STRING
		local
			ent: ENTITY_MOVABLE
			msg: STRING
			temp_pair: PAIR[ENTITY_MOVABLE, STRING]
		do
			create Result.make_empty
			from
			until
				deaths.is_empty
			loop
				temp_pair := deaths.first
				deaths.dequeue
				ent := temp_pair.first
				msg := temp_pair.second
				Result.append ("%N   [" + ent.id.out + "," + ent.item.out + "]->")
				if ent.item = 'E' then
					Result.append ("fuel:" + ent.get_fuel.out + "/3, ")
					Result.append ("life:0/3, landed?:" + ent.is_landed.out.at (1).out + ",%N")
				else
					Result.append ("attached?:" + ent.is_attached.out.at (1).out + ", ")
					Result.append ("support_life?:" + ent.can_support_life.out.at (1).out + ", ")
					Result.append ("visited?:" + ent.is_visited.out.at (1).out + ", ")
					Result.append ("turns_left:N/A,%N")
				end

				Result.append ("    " + msg)
			end
		end


feature -- queries
	 out : STRING
	 	local
	 		ended: BOOLEAN
	 		sectors: STRING
	 		entities: STRING
		do
			create sectors.make_empty
			create entities.make_empty
			create Result.make_empty
			Result.append ("  state:")
			Result.append (state.out)
			Result.append (".")
			Result.append (error_state.out)
			Result.append (", ")

			if state /= 0 and abort_msg.is_empty then
				if test_mode then
					Result.append ("mode:test,")
				else
					Result.append ("mode:play,")
				end
				if error.is_empty then
					Result.append (" ok")
				else
					Result.append (" error")
				end
				Result.append ("%N")

				if not error.is_empty then
					Result.append (error)
					error.wipe_out
				elseif not status_msg.is_empty then
					Result.append (status_msg)
					status_msg.wipe_out
				else
					if not land_msg.is_empty then
						Result.append (land_msg)
						land_msg.wipe_out
						if not in_play then
							make (state, 0)
						end
					end
					if in_play then
						if not planet_msg.is_empty then
							Result.append (planet_msg + "%N")
							planet_msg.wipe_out
						end

						if not liftoff_msg.is_empty then
							Result.append (liftoff_msg + "%N")
							liftoff_msg.wipe_out
						end

						if not fuel_msg.is_empty then
							Result.append (fuel_msg + "%N")
							Result.append ("  The game has ended. You can start a new game.%N")
							ended := True
						end

						if not blackhole_msg.is_empty then
							Result.append (blackhole_msg + "%N")
							Result.append ("  The game has ended. You can start a new game.%N")
							ended := True
						end

						Result.append ("  Movement:")
						if movement.is_empty then
							Result.append ("none")
						else
							Result.append ("%N" + movement)
						end

						if test_mode then
							Result.append ("%N  Sectors:%N")
							Result.append (sectors_out)
							Result.append ("  Descriptions:%N")
							Result.append (entities_out)
							Result.append ("  Deaths This Turn:")
							if deaths.is_empty then
								Result.append("none")
							else
								Result.append (deaths_out)
							end

						end


						Result.append (galaxy_out)

						if test_mode  then
							if not fuel_msg.is_empty then
								Result.append ("%N" + fuel_msg + "%N")
								Result.append ("  The game has ended. You can start a new game.")
							elseif not blackhole_msg.is_empty then
								Result.append ("%N" + blackhole_msg + "%N")
								Result.append ("  The game has ended. You can start a new game.")
							end
						end
					end

				end
			else
				if abort_msg.is_empty then
					Result.append ("ok%N")
					Result.append ("  Welcome! Try test(30)")
				else
					Result.append ("ok%N")
					Result.append (abort_msg + " Try test(30)")
					reset
				end

			end -- not state = 0 or empty abort message
		end --end of out


end --end of class
