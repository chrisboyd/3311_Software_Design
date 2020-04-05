note
	description: "[
		Alphabet allowed to appear on the galaxy board.
	]"
	author: "Kevin Banh"
	date: "April 30, 2019"
	revision: "1"

deferred class
	ENTITY_ALPHABET

inherit

	COMPARABLE
		undefine
			out,
			is_equal
		end

	ANY
		redefine
			out,
			is_equal
		end

feature -- Attributes common to all entities

	item: CHARACTER
			--character that represents the entity

	location: SECTOR
			--location of the entity

	id: INTEGER
			--unique id of the entity

feature --Comparison

	is_less alias "<" (other: LIKE Current): BOOLEAN
			--for sorting by id
		do
			Result := id < other.id
		end

	is_equal (other: LIKE Current): BOOLEAN
			--id and item define equality
		do
			Result := Current.item.is_equal (other.item) and Current.id.is_equal (other.id)
		end

feature -- Query

	out: STRING
			-- Return string representation of the entity
		do
			Result := item.out
		end

	id_out: STRING
			--Returns a string of form: [id,symbol]
		do
			create Result.make_empty
			Result.append ("[" + id.out + "," + item.out + "]")
		end

	loc_out: STRING
			--Returns the full address of the entity [row,column,quadrant]
		do
			create Result.make_empty
			Result.append ("[" + location.row.out + "," + location.column.out + ",")
				--Result.append (location.contents.index_of (Current, 1).out + "]")
			Result.append (location.index_of (Current).out + "]")
		end

	is_stationary: BOOLEAN
			-- Return if current item is stationary.
		do
			if item = 'W' or item = 'Y' or item = '*' or item = 'O' then
				Result := True
			end
		end

	is_movable: BOOLEAN
			-- Return if current item is movable
		do
			if item = 'E' or item = 'A' or item = 'P' or item = 'B' or item = 'M' or item = 'J' then
				Result := True
			end
		end

	is_planet: BOOLEAN
			-- Return if current item is a planet
		do
			if item = 'P' then
				Result := True
			end
		end

	is_explorer: BOOLEAN
			-- Return if current item is the explorer
		do
			if item = 'E' then
				Result := True
			end
		end

	is_blackhole: BOOLEAN
			-- Return if current item is a blackhole
		do
			if item = 'O' then
				Result := True
			end
		end

	is_yellow_dwarf: BOOLEAN
			-- Return if current item is a yellow dwarf star
		do
			if item = 'Y' then
				Result := True
			end
		end

	is_blue_giant: BOOLEAN
			-- Return if current item is a blue giant star
		do
			if item = '*' then
				Result := True
			end
		end

	is_wormhole: BOOLEAN
			-- Return if current item is a wormhole
		do
			if item = 'W' then
				Result := True
			end
		end

	is_benign: BOOLEAN
			-- Return if current item is benign
		do
			if item = 'B' then
				Result := True
			end
		end

	is_malevolent: BOOLEAN
			-- Return if current item is malevolent
		do
			if item = 'M' then
				Result := True
			end
		end

	is_janitaur: BOOLEAN
			-- Return if current item is janitaur
		do
			if item = 'J' then
				Result := True
			end
		end

	is_asteroid: BOOLEAN
			-- Return if current item is an asteroid
		do
			if item = 'A' then
				Result := True
			end
		end

	is_star: BOOLEAN
			-- Return if current item is a star
		do
			if item = 'Y' or item = '*' then
				Result := True
			end
		end

invariant
	allowable_symbols: item = 'E' or item = 'P' or item = 'A' or item = 'M' or item = 'J' or item = 'O' or item = 'W' or item = 'Y' or item = '*' or item = 'B'

end
