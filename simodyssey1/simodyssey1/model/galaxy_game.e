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

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		local
				row : INTEGER
				column : INTEGER
		do
			create s.make_empty
			state := 0
			error_state := 0
			in_play := FALSE
			test_mode := FALSE
			create error.make_empty
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
					grid[row,column] := create {SECTOR}.make(row,column,create{ENTITY_ALPHABET}.make ('E'))
					column:= column + 1;
				end
				row := row + 1
			end


		end

feature {NONE} -- model attributes
	s : STRING
	state : INTEGER
	error_state : INTEGER
	in_play: BOOLEAN
	error : STRING
	test_mode : BOOLEAN
	grid: ARRAY2 [SECTOR]
			-- the board

	gen: RANDOM_GENERATOR_ACCESS

	shared_info_access : SHARED_INFORMATION_ACCESS

	shared_info: SHARED_INFORMATION
		attribute
			Result:= shared_info_access.shared_info
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
			in_play := TRUE
			test(30)
		end
	test (p_threshold : INTEGER)
		do
			state := state + 1
			set_stationary_items
			in_play := TRUE
			test_mode := TRUE

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

feature {NONE} --commands (internal)

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
	set_stationary_items
			-- distribute stationary items amongst the sectors in the grid.
			-- There can be only one stationary item in a sector
		local
			loop_counter: INTEGER
			check_sector: SECTOR
			temp_row: INTEGER
			temp_column: INTEGER
		do
			from
				loop_counter := 1
			until
				loop_counter > shared_info.number_of_stationary_items
			loop

				temp_row :=  gen.rchoose (1, shared_info.number_rows)
				temp_column := gen.rchoose (1, shared_info.number_columns)
				check_sector := grid[temp_row,temp_column]
				if (not check_sector.has_stationary) and (not check_sector.is_full) then
					grid[temp_row,temp_column].put (create_stationary_item)
					loop_counter := loop_counter + 1
				end -- if
			end -- loop
		end -- feature set_stationary_items

	create_stationary_item: ENTITY_ALPHABET
			-- this feature randomly creates one of the possible types of stationary actors
		local
			chance: INTEGER
		do
			chance := gen.rchoose (1, 3)
			inspect chance
			when 1 then
				create Result.make('Y')
			when 2 then
				create Result.make('*')
			when 3 then
				create Result.make('W')
			else
				create Result.make('Y') -- create more yellow dwarfs this will never happen, but create by default
			end -- inspect
		end


feature -- queries
	out : STRING
		do
			create Result.make_empty
			Result.append (" state:")
			Result.append (state.out)
			Result.append (".")
			Result.append (error_state.out)
			Result.append ("%N")

			if not error.is_empty then
				Result.append (error)
			else if in_play then
				Result.append (galaxy_out)
			else
				Result.append (" Welcome! Try test(30)")
			end
			end

		end


end
