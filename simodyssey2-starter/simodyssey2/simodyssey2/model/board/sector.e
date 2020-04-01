note
	description: "Represents a sector in the galaxy."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SECTOR

inherit ANY
	redefine
		out
	end

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
	make(row_input: INTEGER; column_input: INTEGER)
		--Create an empty sector
		require
			valid_row: (row_input >= 1) and (row_input <= shared_info.number_rows)
			valid_column: (column_input >= 1) and (column_input <= shared_info.number_columns)
		do
			row := row_input
			column := column_input
			-- Each sector should have 4 quadrants
			create contents.make (shared_info.max_capacity)
			contents.compare_objects
		end

feature -- commands
	make_dummy
		--initialization without creating entities in quadrants
		do
			create contents.make (shared_info.max_capacity)
			contents.compare_objects
		end


	out: STRING
		--build a string with [row,col] for the sector
		do
			create Result.make_empty
			Result.append (row.out)
			Result.append (":")
			Result.append (column.out)
		end

	contents_out: STRING
		--build a string of [row,col]->[id,symbol],[id,symbol],[id,symbol],[id,symbol]
		--or a '-' in quadrants with no entity
		local

			printed_symbols: INTEGER
			component: ENTITY_ALPHABET
		do
			create Result.make_empty

			printed_symbols := 0
			Result.append ("    [" + row.out + "," + column.out + "]->")

			across
				contents as quadrant
			loop
				component := quadrant.item
				if attached component as entity then
					Result.append ("[" + entity.id.out + "," + entity.item.out + "]")
				else
					Result.append ("-")
				end
				printed_symbols := printed_symbols + 1
				if (shared_info.max_capacity - printed_symbols) /= 0 then
					Result.append (",")
				end
			end
			from
			until
				(shared_info.max_capacity - printed_symbols) = 0
			loop
				Result.append ("-")
				printed_symbols := printed_symbols + 1
				if (shared_info.max_capacity - printed_symbols) /= 0 then
					Result.append (",")
				end
			end
		end

feature --command

	put (entity: ENTITY_ALPHABET)
			-- put `new_component' in contents array at the first available quadrant
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
					contents [loop_counter] := entity
				else
					loop_counter := loop_counter + 1
				end

			end -- loop

			if not found and not is_full then
				contents.extend (entity)
			end

		ensure
			component_put: not is_full implies contents.has (entity)
		end

	remove(entity: ENTITY_ALPHABET)
		--remove entity from the quadrant by setting the index of entity to void
		require
			in_sector: contents.index_of (entity, 1) > 0
		local
			index_remove: INTEGER
		do
			index_remove := contents.index_of (entity, 1)
			contents[index_remove] := Void
		end

feature -- Queries

--	print_sector: STRING
--			-- Printable version of location's coordinates with different formatting
--			--REPLACE USAGE WITH OUT
--		do
--			Result := ""
--			Result.append (row.out)
--			Result.append (":")
--			Result.append (column.out)
--		end

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

	next_available_quad: INTEGER
		--find the next empty quadrant of the sector
		require
			not is_full
		local
			loop_counter: INTEGER
			occupant: ENTITY_ALPHABET
			empty_space_found: BOOLEAN
		do
			empty_space_found := FALSE
			from
				loop_counter := 1
			until
				loop_counter > contents.count or empty_space_found
			loop
				occupant := contents [loop_counter]
				if not attached occupant then
					empty_space_found := TRUE
				else
					loop_counter := loop_counter + 1
				end
			end
			Result := loop_counter
		end

	get_stationary: ENTITY_STATIONARY
		--Return a reference to the ENTITY_STATIONARY in this sector,
		--must contain an ENTITY_STATIONARY
		require
			Current.has_stationary
		local
			loop_counter: INTEGER
		do
			--dummy entity
			Result := create {WORMHOLE}.make(-15, create {SECTOR}.make_dummy)
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

	has_star: BOOLEAN
		--Returns TRUE if this sector contains a star
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

	has_wormhole: BOOLEAN
		--Returns TRUE if this sector contains a wormhole
		local
			loop_counter: INTEGER
		do
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

	has_blackhole: BOOLEAN
		--Returns TRUE if this sector contains a blackhole
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

	has_benign: BOOLEAN
		--Returns TRUE if this sector contains a Benign entity
		local
			loop_counter: INTEGER
		do
			from
				loop_counter := 1
			until
				loop_counter > contents.count or Result
			loop
				if attached contents [loop_counter] as temp_item  then
					Result := temp_item.is_benign
				end -- if
				loop_counter := loop_counter + 1
			end
		end

	has_yellow_dwarf: BOOLEAN
		--Returns TRUE if this sector contains a Yellow Dwarf star
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

	has_planet: BOOLEAN
		--Returns TRUE if this sector contains a Planet
		local
			loop_counter: INTEGER
		do
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

	get_movables: SORTED_TWO_WAY_LIST[ENTITY_MOVABLE]
		--Return a list of the movable entities in this sector sorted by id.
		--Can be an empty list
		local
			loop_counter: INTEGER
		do
			create Result.make

			from
				loop_counter := 1
			until
				loop_counter > contents.count
			loop
				if attached contents [loop_counter] as entity  then
					if entity.is_movable then
						check attached {ENTITY_MOVABLE} entity as m then
							Result.extend (m)
							end
					end

				end -- if
				loop_counter := loop_counter + 1
			end

		end

end
