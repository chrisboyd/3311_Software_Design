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
	in_play: BOOLEAN			--is there a game currently active
	error : STRING			--error message to output to player
	test_mode : BOOLEAN		-- is the game in test mode
	grid: ARRAY2 [SECTOR] 	-- the board
	movable_entities: SORTED_TWO_WAY_LIST[ENTITY_MOVABLE]
	stationary_entities: SORTED_TWO_WAY_LIST[ENTITY_STATIONARY]
	explorer : ENTITY_MOVABLE

	gen: RANDOM_GENERATOR_ACCESS

	shared_info_access : SHARED_INFORMATION_ACCESS

	shared_info: SHARED_INFORMATION
		attribute
			Result:= shared_info_access.shared_info
		end

feature {NONE} -- Initialization
	make
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
			create explorer.make ('E', 1)
			create blackhole.make ('O', -1)

			movable_entities.extend (explorer)
			stationary_entities.extend (blackhole)

			state := 0
			error_state := 0
			in_play := FALSE
			test_mode := FALSE
			create error.make_empty
			create fuel_msg.make_empty
			create blackhole_msg.make_empty

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
			make
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
		do
			error.append ("movable addresses:%N")
			across
				movable_entities as m
			loop
				error.append ("row: " + m.item.row.out)
				error.append ( " col: " + m.item.col.out + "%N")
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
					state := state + 1
					explorer.use_fuel
					sect := grid[explorer.row, explorer.col]
					sect.contents.prune (explorer)
					explorer.set_location (coord.first, coord.second)

					--check if explorer is out of fuel, and thus, dead					
					if explorer.fuel_empty then
						fuel_msg.append ("  Explorer got lost in space - out of fuel at Sector:")
						fuel_msg.append (grid[explorer.row, explorer.col].print_sector)
					else
						grid[coord.first, coord.second].put (explorer)
					end

					--check if there are stationary entities in sector
					--check if it is star to refuel or blackhole and explorer dies
					if grid[coord.first, coord.second].has_stationary then
						stationary := grid[coord.first, coord.second].get_stationary
						if stationary.is_blue_giant then
							explorer.add_fuel (5)
						elseif stationary.is_yellow_dwarf then
							explorer.add_fuel (2)
						elseif stationary.is_blackole then
							blackhole_msg.append ("  Explorer got devoured by blackhole (id: -1) at Sector:3:3")
							grid[coord.first, coord.second].contents.prune (explorer)
						end

					end


				end--end of landed if

			end -- end of in_play if

		end

feature {NONE} --commands (internal)

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
				end
				loop_counter := loop_counter + 1
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
				if quad.is_stationary then
					stationary := TRUE
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
			turn :INTEGER
			id: INTEGER
			row_counter: INTEGER
			col_counter: INTEGER
		do
			id := 2 --since Explorer id := 1
			from
				row_counter := 1
			until
				row_counter > shared_info.number_rows
			loop
				from
					col_counter := 1
				until
					col_counter > shared_info.number_columns
				loop

					number_items := gen.rchoose (1, shared_info.max_capacity-1)  -- MUST decrease max_capacity by 1 to leave space for Explorer (so a max of 3)
					from
						loop_counter := 1
					until
						loop_counter > number_items
					loop
						threshold := gen.rchoose (1, 100) -- each iteration, generate a new value to compare against the threshold values provided by `test` or `play`

						if threshold < p_threshold then
							create component.make('P', id)
							movable_entities.extend (component)
							id := id + 1
						end

						--couldn't use row /= 3 and col /= 3 due to eiffel's handling of boolean test
						--would instantly stop ie, wouldn't put anything in row 3 or column 3
						if attached component as entity then
							if row_counter = 3 then
								if col_counter /= 3 then
									grid[row_counter, col_counter].put(entity)  -- add new entity to the contents list
									entity.set_location (row_counter, col_counter)
									--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
									turn:=gen.rchoose (0, 2) -- Hint: Use this number for assigning turn values to the planet created
									-- The turn value of the planet created (except explorer) suggests the number of turns left before it can move.
									--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
									component.set_turn (turn)
								end
							else
								grid[row_counter, col_counter].put(entity)  -- add new entity to the contents list
								entity.set_location (row_counter, col_counter)
								--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
								turn:=gen.rchoose (0, 2) -- Hint: Use this number for assigning turn values to the planet created
								-- The turn value of the planet created (except explorer) suggests the number of turns left before it can move.
								--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
								component.set_turn (turn)
							end

							component := void -- reset component object
						end
						loop_counter := loop_counter + 1
					end
					col_counter := col_counter + 1
				end
				row_counter := row_counter + 1
			end
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

	return_m_ent_low_high (sect: SECTOR) : SEQ[ENTITY_ALPHABET]
		local
			temp: SEQ[ENTITY_ALPHABET]
			i: INTEGER
			inserted : BOOLEAN
		do
			create temp.make_empty

			across
				sect.contents is ent
			loop
				if ent.is_movable then
					if temp.is_empty then
						temp.append (ent)
					else
						from
							i := temp.lower
						until
							i > temp.upper or inserted
						loop
							if ent.id <= temp[i].id then
								temp.insert (ent, i)
								inserted := True
							end
							i := i + 1
						end--insert current movable entity into temp in order of id
						if not inserted then
							temp.append (ent)
						end
					end--temp was empty, inserted current movable into front of temp
				end--current entity wasn't movable
			end--end of across entities of sect

			Result := temp
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


feature -- queries
	out : STRING
		do
			create Result.make_empty
			Result.append ("  state:")
			Result.append (state.out)
			Result.append (".")
			Result.append (error_state.out)
			Result.append ("%N")

			if not error.is_empty then
				Result.append (error)
			else if in_play then
				if not fuel_msg.is_empty then
					Result.append (fuel_msg + "%N")
					Result.append ("  The game has ended. You can start a new game.")
					in_play := False
					--**********
					--have to recreate board to prep for user entering play / test
					--**********
				elseif not blackhole_msg.is_empty then
					Result.append (blackhole_msg + "%N")
					Result.append ("  The game has ended. You can start a new game.")
					in_play := False
				end
				Result.append (galaxy_out)
			else
				Result.append ("  Welcome! Try test(30)")
			end
			end

		end


end
