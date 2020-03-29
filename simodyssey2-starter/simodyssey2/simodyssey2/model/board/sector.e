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
		--initialization
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

	populate_movable(a_thresh: INTEGER; j_thresh: INTEGER; m_thresh: INTEGER;
					b_thresh: INTEGER; p_thresh: INTEGER)
			-- this feature creates 1 to max_capacity-1 components to be intially stored in the
			-- sector. The component may be a planet or nothing at all.
		local
			threshold: INTEGER
			number_items: INTEGER
			loop_counter: INTEGER
			component: ENTITY_MOVABLE
			turn :INTEGER
			movable_id: INTEGER
		do
			movable_id := 1 --since explorer is 0
			-- MUST decrease max_capacity by 1 to leave space for Explorer (so a max of 3)
			number_items := gen.rchoose (1, shared_info.max_capacity-1)
			from
				loop_counter := 1
			until
				loop_counter > number_items
			loop
				-- each iteration, generate a new value to compare against the threshold values
				--provided by `test` or `play`
				threshold := gen.rchoose (1, 100)

				if threshold < a_thresh then
					component :=	create {ASTEROID}.make(movable_id, Current)
					movable_id := movable_id + 1
				else
					if threshold < j_thresh then
						component :=	create {JANITAUR}.make(movable_id, Current)
						movable_id := movable_id + 1
					else
						if threshold < m_thresh then
							component :=	create {MALEVOLENT}.make(movable_id, Current)
							movable_id := movable_id + 1
						else
							if threshold < b_thresh then
								component :=	create {BENIGN}.make(movable_id, Current)
								movable_id := movable_id + 1
							else
								if threshold < p_thresh then
									component :=	create {PLANET}.make(movable_id, Current)
									movable_id := movable_id + 1
								end
							end
						end
					end
				end

				if attached component as entity then
					put (entity) -- add new entity to the contents list

					--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
					turn:=gen.rchoose (0, 2) -- Hint: Use this number for assigning turn values to movable entities
					-- The turn value of a movable entity (except explorer) suggests the number of turns left before it can move.
					--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
					component.set_turns (turn)
					component := void -- reset component object
				end

				loop_counter := loop_counter + 1
			end
		end

	out: STRING
		do
			create Result.make_empty
			Result.append (row.out)
			Result.append (":")
			Result.append (column.out)
		end

feature --command

	put (entity: ENTITY_ALPHABET)
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
		local
			index_remove: INTEGER
		do
			index_remove := contents.index_of (entity, 1)
			contents[index_remove] := Void

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

	next_available_quad: INTEGER
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

end
