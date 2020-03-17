note
	description: "Represents a sector in the galaxy."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SECTOR

create
	make, make_dummy

feature -- attributes
	shared_info_access : SHARED_INFORMATION_ACCESS

	shared_info: SHARED_INFORMATION
		attribute
			Result:= shared_info_access.shared_info
		end

	gen: RANDOM_GENERATOR_ACCESS

	contents: ARRAYED_LIST [detachable ENTITY_ALPHABET] --holds 4 quadrants

	row: INTEGER

	column: INTEGER

feature -- constructor
	make(row_input: INTEGER; column_input: INTEGER; a_explorer:ENTITY_ALPHABET; blackhole:ENTITY_ALPHABET)
		--initialization
		require
			valid_row: (row_input >= 1) and (row_input <= shared_info.number_rows)
			valid_column: (column_input >= 1) and (column_input <= shared_info.number_columns)
		do
			row := row_input
			column := column_input
			create contents.make (shared_info.max_capacity) -- Each sector should have 4 quadrants
			contents.compare_objects
			if (row = 3) and (column = 3) then
				put (blackhole) -- If this is the sector in the middle of the board, place a black hole
				blackhole.set_location (row, column)
			else
				if (row = 1) and (column = 1) then
					put (a_explorer) -- If this is the top left corner sector, place the explorer there
					a_explorer.set_location (row, column)
				end
				--populate -- Run the populate command to complete setup
			end -- if
		end

feature -- commands
	make_dummy
		--initialization without creating entities in quadrants
		do
			create contents.make (shared_info.max_capacity)
			contents.compare_objects
		end

feature {GALAXY_GAME} --command

	put (new_component: ENTITY_ALPHABET)
			-- put `new_component' in contents array
		local
			loop_counter: INTEGER
			found: BOOLEAN
			occupant : ENTITY_ALPHABET
		do
			from
				loop_counter := 1
			until
				loop_counter > contents.count or found
			loop

				occupant := contents [loop_counter]
				if not attached occupant  then
					found := TRUE
					contents [loop_counter] := new_component
				else
					loop_counter := loop_counter + 1
				end

			end -- loop

			if not found and not is_full then
				contents.extend (new_component)
			end

		ensure
			component_put: not is_full implies contents.has (new_component)
		end

	get_stationary: ENTITY_STATIONARY
		require
			Current.has_stationary
		local
			loop_counter: INTEGER
		do
			--dummy entity
			Result := create {ENTITY_STATIONARY}.make('W', -10)
			from
				loop_counter := 1
			until
				loop_counter > contents.count
			loop
				if attached {ENTITY_STATIONARY} contents [loop_counter] as temp_item  then
					if temp_item.is_stationary then
						Result := temp_item
					end
				end -- if
				loop_counter := loop_counter + 1
			end
		end

feature -- Queries

	print_sector: STRING
			-- Printable version of location's coordinates with different formatting
		do
			Result := ""
			Result.append (row.out)
			Result.append (":")
			Result.append (column.out)
		end

	is_full: BOOLEAN
			-- Is the location currently full?
		local
			loop_counter: INTEGER
			occupant: ENTITY_ALPHABET
			empty_space_found: BOOLEAN
		do
			if contents.count < shared_info.max_capacity then
				empty_space_found := TRUE
			end
			from
				loop_counter := 1
			until
				loop_counter > contents.count or empty_space_found
			loop
				occupant := contents [loop_counter]
				if not attached occupant  then
					empty_space_found := TRUE
				end
				loop_counter := loop_counter + 1
			end

			if contents.count = shared_info.max_capacity and then not empty_space_found then
				Result := TRUE
			else
				Result := FALSE
			end
		end

	has_stationary: BOOLEAN
			-- returns whether the location contains any stationary item
		local
			loop_counter: INTEGER
		do
			from
				loop_counter := 1
			until
				loop_counter > contents.count or Result
			loop
				if attached contents [loop_counter] as temp_item  then
					Result := temp_item.is_stationary
				end -- if
				loop_counter := loop_counter + 1
			end
		end

	has_movable: BOOLEAN
			-- returns whether the location contains any movable item
		local
			loop_counter: INTEGER
		do
			from
				loop_counter := 1
			until
				loop_counter > contents.count or Result
			loop
				if attached contents [loop_counter] as temp_item  then
					Result := temp_item.is_movable
				end -- if
				loop_counter := loop_counter + 1
			end
		end


	has_star: BOOLEAN
		local
			loop_counter: INTEGER
		do
			from
				loop_counter := 1
			until
				loop_counter > contents.count or Result
			loop
				if attached contents [loop_counter] as temp_item  then
					Result := temp_item.is_yellow_dwarf or temp_item.is_blue_giant
				end -- if
				loop_counter := loop_counter + 1
			end
		end

	has_yellow_dwarf: BOOLEAN
		local
			loop_counter: INTEGER
		do
			from
				loop_counter := 1
			until
				loop_counter > contents.count or Result
			loop
				if attached contents [loop_counter] as temp_item  then
					Result := temp_item.is_yellow_dwarf
				end -- if
				loop_counter := loop_counter + 1
			end
		end

	has_blackhole: BOOLEAN
		local
			loop_counter: INTEGER
		do
			from
				loop_counter := 1
			until
				loop_counter > contents.count or Result
			loop
				if attached contents [loop_counter] as temp_item  then
					Result := temp_item.is_blackhole
				end -- if
				loop_counter := loop_counter + 1
			end
		end

	has_wormhole: BOOLEAN
		local
			loop_counter: INTEGER
		do
			if Current.has_stationary then
				from
					loop_counter := 1
				until
					loop_counter > contents.count or Result
				loop
					if attached contents [loop_counter] as temp_item  then
						Result := temp_item.is_wormhole
					end -- if
					loop_counter := loop_counter + 1
				end
			end
		end

	has_planet: BOOLEAN
		local
			loop_counter: INTEGER
		do
			if Current.has_movable then
				from
					loop_counter := 1
				until
					loop_counter > contents.count or Result
				loop
					if attached contents [loop_counter] as temp_item  then
						Result := temp_item.is_planet
					end -- if
					loop_counter := loop_counter + 1
				end
			end
		end

	get_planets: SORTED_TWO_WAY_LIST[ENTITY_MOVABLE]
		require
			Current.has_planet
		do
			create Result.make
			across
				contents as quadrant
			loop
				if attached {ENTITY_MOVABLE} quadrant.item as q then
					if q.is_planet then
						Result.extend (q)
					end
				end
			end
		end
end
