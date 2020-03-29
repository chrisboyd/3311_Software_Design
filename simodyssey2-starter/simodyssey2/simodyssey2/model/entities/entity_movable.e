note
	description: "Summary description for {ENTITY_MOVABLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ENTITY_MOVABLE

inherit
	ENTITY_ALPHABET

feature --attributes
	turns_left: INTEGER
	fuel: INTEGER
	life: INTEGER
	death_msg: STRING

feature --commands
	set_turns(i: INTEGER)
		do
			turns_left := i
		end

	move(dest: SECTOR)
		do
			--remove from location, add to destination
			dest.put (Current)
			location.remove (Current)
			location := dest

			--use fuel planets and asteroids don't need this
			fuel := fuel - 1
		end

	check_post_move
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
			--handle situation of out of fuel and in blackhole sector,
			--explorer dies by out of fuel first
			elseif fuel = 0 then
				life := 0
			elseif location.has_blackhole then
				life := 0
			end

			if fuel = 0 then
				life := 0
			end

		end

	wormhole(board: GALAXY)
		local
			gen: RANDOM_GENERATOR_ACCESS
			added: BOOLEAN
			temp_row: INTEGER
			temp_col: INTEGER
		do
			from
				added := False
			until
				added
			loop
				temp_row := gen.rchoose (1, 5)
				temp_col := gen.rchoose (1, 5)

				if not board.grid[temp_row, temp_col].is_full then
					board.grid[location.row, location.column].remove (Current)
					board.grid[temp_row, temp_col].put (Current)
					location := board.grid[temp_row, temp_col]
					added := True
				end

			end
		end

	get_death_msg: STRING
		do
			create Result.make_empty
			Result.append (Current.get_name)
		end

	set_death_msg(msg: STRING)
		do
		end

	is_dead: BOOLEAN
		do
			Result := life = 0
		end

feature --deferred command

	reproduce
		deferred
		end

	behave
		deferred
		end

	get_name: STRING
		deferred
		end


end
