note
	description: "Galaxy represents a game board in simodyssey."
	author: "Kevin B"
	date: "$Date$"
	revision: "$Revision$"

class
	GALAXY

inherit

	ANY
		redefine
			out
		end

create
	make

feature {NONE} --hidden attributes

	grid: ARRAY2 [SECTOR]
			-- the board

feature -- attributes

	movable_id: INTEGER
		--value of the next id to assign to a new MOVABLE_ENTITY

	gen: RANDOM_GENERATOR_ACCESS

	shared_info_access: SHARED_INFORMATION_ACCESS

	shared_info: SHARED_INFORMATION
		attribute
			Result := shared_info_access.shared_info
		end

	movable_entities: SORTED_TWO_WAY_LIST [ENTITY_MOVABLE]
		--all of the movable entities in the galaxy, sorted by increasing id

	stationary_entities: SORTED_TWO_WAY_LIST [ENTITY_STATIONARY]
		--all of the stationary entities in the galaxy, sorted by increasing id

	explorer: EXPLORER
		--the galaxies intrepid explorer, the players regent

feature --constructor

	make
			-- creates a dummy of galaxy grid
			-- Places the explorer at [1,] and a blackhole at [3,3]
		local
			row: INTEGER
			column: INTEGER
			blackhole: ENTITY_STATIONARY
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
					grid [row, column] := create {SECTOR}.make (row, column)
					column := column + 1;
				end
				row := row + 1
			end
				--initialize movable and stationary lists
			create movable_entities.make
			movable_entities.compare_objects
			create stationary_entities.make
			stationary_entities.compare_objects

				--put explorer in grid
			movable_id := 0
			explorer := create {EXPLORER}.make (movable_id, grid [1, 1])
			movable_id := movable_id + 1
			grid [1, 1].put (explorer)
			movable_entities.extend (explorer)
				--put blackhole in grid
			blackhole := create {BLACKHOLE}.make (-1, grid [3, 3])
			grid [3, 3].put (blackhole)
			stationary_entities.extend (blackhole)
		end

feature --commands

	set_movable_items (a_thresh: INTEGER; j_thresh: INTEGER; m_thresh: INTEGER; b_thresh: INTEGER; p_thresh: INTEGER)
			--Set a random number of movable entites at each sector.
			--Likelihood of each entity type is defined as:
			--Asteroid (0,a_thresh], Janitaur [a_thresh,j_thresh],
			--Malevolent [m_thresh,b_thresh], Benign[b_thresh,p_thresh] and
			--Plent[p_thresh,101]
		require
			valid_threshold: 0 < a_thresh and a_thresh <= j_thresh and j_thresh <= m_thresh and m_thresh <= b_thresh and b_thresh <= p_thresh and p_thresh <= 101
		local
			threshold: INTEGER
			number_items: INTEGER
			loop_counter: INTEGER
			component: ENTITY_MOVABLE
			turn: INTEGER
		do
			across
				1 |..| shared_info.number_rows as r
			loop
				across
					1 |..| shared_info.number_columns as c
				loop
					if not (r.item = 3 and c.item = 3) then

							-- MUST decrease max_capacity by 1 to leave space for Explorer (so a max of 3)
						number_items := gen.rchoose (1, shared_info.max_capacity - 1)
						from
							loop_counter := 1
						until
							loop_counter > number_items
						loop
								-- each iteration, generate a new value to compare against the threshold values
								--provided by `test` or `play`
							threshold := gen.rchoose (1, 100)
							if threshold < a_thresh then
								component := create {ASTEROID}.make (movable_id, grid [r.item, c.item])
								movable_id := movable_id + 1
							else
								if threshold < j_thresh then
									component := create {JANITAUR}.make (movable_id, grid [r.item, c.item])
									movable_id := movable_id + 1
								else
									if threshold < m_thresh then
										component := create {MALEVOLENT}.make (movable_id, grid [r.item, c.item])
										movable_id := movable_id + 1
									else
										if threshold < b_thresh then
											component := create {BENIGN}.make (movable_id, grid [r.item, c.item])
											movable_id := movable_id + 1
										else
											if threshold < p_thresh then
												component := create {PLANET}.make (movable_id, grid [r.item, c.item])
												movable_id := movable_id + 1
											end
										end
									end
								end
							end
							if attached component as entity then
								grid [r.item, c.item].put (entity) -- add new entity to the contents list

									--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
								turn := gen.rchoose (0, 2) -- Hint: Use this number for assigning turn values to movable entities
									-- The turn value of a movable entity (except explorer) suggests the number of turns left before it can move.
									--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
								component.set_turns (turn)
								movable_entities.extend (component)
								component := void -- reset component object
							end
							loop_counter := loop_counter + 1
						end
					end
				end
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
			stationary_id: INTEGER
		do
			stationary_id := -2
			from
				loop_counter := 1
			until
				loop_counter > shared_info.number_of_stationary_items
			loop
				temp_row := gen.rchoose (1, shared_info.number_rows)
				temp_column := gen.rchoose (1, shared_info.number_columns)
				check_sector := grid [temp_row, temp_column]
				if (not check_sector.has_stationary) and (not check_sector.is_full) then
					grid [temp_row, temp_column].put (create_stationary_item (stationary_id, grid [temp_row, temp_column]))
					stationary_id := stationary_id - 1
					loop_counter := loop_counter + 1
				end -- if
			end -- loop
		end -- feature set_stationary_items

	create_stationary_item (id: INTEGER; location: SECTOR): ENTITY_STATIONARY
			-- this feature randomly creates one of the possible types of stationary actors
		local
			chance: INTEGER
			entity: ENTITY_STATIONARY
		do
			chance := gen.rchoose (1, 3)
			inspect chance
			when 1 then
				entity := create {YELLOW_DWARF}.make (id, location)
			when 2 then
				entity := create {BLUE_GIANT}.make (id, location)
			when 3 then
				entity := create {WORMHOLE}.make (id, location)
			else
					-- create more yellow dwarfs this will never happen, but create by default
				entity := create {YELLOW_DWARF}.make (id, location)
			end -- inspect
			stationary_entities.extend (entity)
			Result := entity
		end

	inc_movable_id
			--increments the movable id, used by model to
			--set id of entities created in the reproduce phase of a turn
		do
			movable_id := movable_id + 1
		end

feature -- query

	get_sector (row: INTEGER; col: INTEGER): SECTOR
		require
			in_bounds: row <= shared_info.number_rows and col <= shared_info.number_columns
		do
			Result := grid [row, col]
		end

	get_sector_desc: STRING
			--Builds a string representation of all of the entity id's and
			--sybmols at each quadrant of each sector
			--Used for the 'Section' output in test mode
		do
			create Result.make_empty
			across
				grid as sector
			loop
				Result.append (sector.item.contents_out)
				if not sector.after then
					Result.append ("%N")
				end
			end
		end

	get_entity_desc: STRING
			--Build a string representing all stationary and
			--movable entities currently on the board and the entities
			--vital stats
		do
			create Result.make_empty
			across
				stationary_entities as s
			loop
				Result.append (s.item.get_status + "%N")
			end
			across
				movable_entities as m
			loop
				Result.append (m.item.get_status + "%N")
			end
		end

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
			create string1.make (7 * shared_info.number_rows)
			create string2.make (7 * shared_info.number_columns)
			from
				row_counter := 1
			until
				row_counter > shared_info.number_rows
			loop
				string1.append ("    ")
				string2.append ("    ")
				from
					column_counter := 1
				until
					column_counter > shared_info.number_columns
				loop
					temp_sector := grid [row_counter, column_counter]
					string1.append ("(")
					string1.append (temp_sector.out)
					string1.append (")")
					string1.append ("  ")
					from
						contents_counter := 1
						printed_symbols_counter := 0
					until
						contents_counter > temp_sector.number_entities
					loop
						temp_component := temp_sector.item_at (contents_counter)
						if attached temp_component as character then
							string2.append_character (character.item)
						else
							string2.append ("-")
						end -- if
						printed_symbols_counter := printed_symbols_counter + 1
						contents_counter := contents_counter + 1
					end -- loop

					from
					until
						(shared_info.max_capacity - printed_symbols_counter) = 0
					loop
						string2.append ("-")
						printed_symbols_counter := printed_symbols_counter + 1
					end
					string2.append ("   ")
					column_counter := column_counter + 1
				end -- loop
				string1.append ("%N")
				if not (row_counter = shared_info.number_rows) then
					string2.append ("%N")
				end
				Result.append (string1.twin)
				Result.append (string2.twin)
				row_counter := row_counter + 1
				string1.wipe_out
				string2.wipe_out
			end
		end

end
