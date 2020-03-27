note
	description: "Galaxy represents a game board in simodyssey."
	author: "Kevin B"
	date: "$Date$"
	revision: "$Revision$"

class
	GALAXY

inherit ANY
	redefine
		out
	end

create
	make

feature -- attributes

	grid: ARRAY2 [SECTOR]
			-- the board

	gen: RANDOM_GENERATOR_ACCESS

	shared_info_access : SHARED_INFORMATION_ACCESS

	shared_info: SHARED_INFORMATION
		attribute
			Result:= shared_info_access.shared_info
		end

	movable_entities: SORTED_TWO_WAY_LIST [ENTITY_MOVABLE]

	stationary_entities: SORTED_TWO_WAY_LIST [ENTITY_STATIONARY]

	explorer: ENTITY_MOVABLE

feature --constructor

	make
		-- creates a dummy of galaxy grid
		local
			row : INTEGER
			column : INTEGER
			blackhole: ENTITY_STATIONARY
			planet: ENTITY_MOVABLE
		do
			--make an empty board
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
					grid[row,column] := create {SECTOR}.make(row,column)
					column:= column + 1;
				end
				row := row + 1
			end
			--initialize movable and stationary lists
			create movable_entities.make
			movable_entities.compare_objects
			create stationary_entities.make
			stationary_entities.compare_objects

			--put explorer in grid
			explorer := create {EXPLORER}.make(0,grid[1,1])
			grid[1,1].put (explorer)
			movable_entities.extend (explorer)

			--put blackhole in grid
			blackhole := create {BLACKHOLE}.make (-1, grid[3,3])
			grid[3,3].put (blackhole)
			stationary_entities.extend (blackhole)

			--test dynamic inheritance
			planet := create {PLANET}.make (1, grid[1,1])
			movable_entities.extend (planet)

			--set_stationary_items
	end

feature --commands

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
					grid[temp_row,temp_column].put (create_stationary_item (grid[temp_row, temp_column]))
					loop_counter := loop_counter + 1
				end -- if
			end -- loop
		end -- feature set_stationary_items

	create_stationary_item(location: SECTOR): ENTITY_STATIONARY
			-- this feature randomly creates one of the possible types of stationary actors
		local
			chance: INTEGER
			stationary_id: INTEGER
		do
			stationary_id := -2
			chance := gen.rchoose (1, 3)
			inspect chance
			when 1 then
				Result := create {YELLOW_DWARF}.make(stationary_id, location)
				stationary_id := stationary_id - 1
			when 2 then
				Result := create {BLUE_GIANT}.make(stationary_id, location)
				stationary_id := stationary_id - 1
			when 3 then
				Result := create {WORMHOLE}.make(stationary_id, location)
				stationary_id := stationary_id - 1
			else
				-- create more yellow dwarfs this will never happen, but create by default
				Result := create {YELLOW_DWARF}.make(stationary_id, location)
				stationary_id := stationary_id - 1
			end -- inspect
		end

feature -- query
	out: STRING
	--Returns grid in string form
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


end
