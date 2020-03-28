note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MODEL

inherit
	ANY
		redefine
			out
		end

create {ETF_MODEL_ACCESS}
	make

feature {NONE} -- Initialization

    --info: SHARED_INFORMATION

    -- Initialization for `Current'
	make
		do
			create board.make
			create error_msg.make_empty
		end

feature -- model attributes
	board : GALAXY
	play_mode: BOOLEAN
	test_mode: BOOLEAN
	error_msg: STRING
	game_state: INTEGER
	error_state: INTEGER
	shared_info_access : SHARED_INFORMATION_ACCESS

	shared_info: SHARED_INFORMATION
		attribute
			Result:= shared_info_access.shared_info
		end

feature -- model operations
	default_update
			-- Perform update to the model state.
		do

		end

	reset
			-- Reset model state.
		do
			make
		end

feature --Commands
	set_play(b: BOOLEAN)
		do
			play_mode := b
		end

	set_test(b: BOOLEAN)
		do
			test_mode := b
		end

	set_error(msg: STRING)
		do
			error_msg := msg
			error_state := error_state + 1
		end

	initialize_game(a_thresh: INTEGER; j_thresh: INTEGER; m_thresh: INTEGER;
					b_thresh: INTEGER; p_thresh: INTEGER)
		do
			--initialize board with all movable entities
			--currently uses RNG in blackholes sector, need to stop
			across
				board.grid as sect
			loop

				if not sect.item.contents.has (create {BLACKHOLE}.make (-1, sect.item)) then
					sect.item.populate_movable (a_thresh, j_thresh, m_thresh, b_thresh, p_thresh)
				end

			end

			--initialize board with all stationary entities
			--do separate from movable due to random number generator
			board.set_stationary_items
		end

	move_explorer(dest_row: INTEGER; dest_col: INTEGER)
		do
			board.explorer.move (board.grid[dest_row, dest_col])
			board.explorer.check_post_move
		end


feature -- queries
	out : STRING
		do
			create Result.make_empty
			if not error_msg.is_empty then
				Result.append (error_msg)
			else
				Result.append (board.out)
			end

		end

feature --support
	map_direction(direction: INTEGER):PAIR[INTEGER, INTEGER]
		do
			inspect direction
				when 1 then --N
					create Result.make (-1, 0)
				when 2 then --NE
					create Result.make (-1, 1)
				when 3 then --E
					create Result.make (0, 1)
				when 4 then --SE
					create Result.make (1, 1)
				when 5 then --S
					create Result.make (1, 0)
				when 6 then --SW
					create Result.make (1, -1)
				when 7 then --W
					create Result.make (0, -1)
				when 8 then --NW
					create Result.make (-1, -1)
				else
					create Result.make (0, 0)
				end -- inspect
		end


	get_new_coord (start: PAIR [INTEGER, INTEGER]; increment: PAIR [INTEGER, INTEGER]): PAIR [INTEGER, INTEGER]
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
			Result := create {PAIR [INTEGER, INTEGER]}.make (row_dest, col_dest)
		end

end




