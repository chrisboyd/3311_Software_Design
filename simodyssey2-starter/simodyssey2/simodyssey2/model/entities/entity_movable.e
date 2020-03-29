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
	landed: BOOLEAN

feature --commands
	set_turns(i: INTEGER)
		do
			turns_left := i
		end

feature --deferred command
	move(dest: SECTOR)
		deferred
		end

	check_post_move
		deferred
		end

	reproduce
		deferred
		end

	behave
		deferred
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


end
