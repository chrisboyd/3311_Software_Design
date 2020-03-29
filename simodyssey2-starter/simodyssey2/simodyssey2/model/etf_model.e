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
			create death_msg.make_empty
		end

feature -- model attributes
	board : GALAXY
	play_mode: BOOLEAN
	test_mode: BOOLEAN
	error_msg: STRING
	death_msg: STRING
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
			game_state := game_state + 1
			error_state := 0
		end

	set_test(b: BOOLEAN)
		do
			test_mode := b
			game_state := game_state + 1
			error_state := 0
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
			board.set_movable_items (a_thresh, j_thresh, m_thresh, b_thresh, p_thresh)
			--initialize board with all stationary entities
			--do separate from movable due to random number generator
			board.set_stationary_items

		end

	move_explorer(dest_row: INTEGER; dest_col: INTEGER)
		do
			board.explorer.move (board.grid[dest_row, dest_col])
			game_state := game_state + 1
			error_state := 0
			board.explorer.check_post_move
			--check for explorer death
			update_movables

		end
	wormhole_explorer
		do
			board.explorer.wormhole (board)
			game_state := game_state + 1
			error_state := 0
			board.explorer.check_post_move
			--check for explorer death
			update_movables
		end


feature -- queries
	out : STRING
		do
			create Result.make_empty
			Result.append ("  state:" + game_state.out + "." + error_state.out + ",")
			if play_mode then
				Result.append(" mode:play,")
			elseif test_mode then
				Result.append (" mode:test,")
			end

			if not error_msg.is_empty then
				Result.append (" error%N")
				Result.append ("  " + error_msg)
			else
				Result.append (" ok%N")
				if not (play_mode or test_mode) then
					Result.append ("  Welcome! Try test(3,5,7,15,30)")
				else
					Result.append (board.out)
				end

			end
			--wipe messages
			error_msg.wipe_out

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

	update_movables
		local
			life: INTEGER
			gen: RANDOM_GENERATOR_ACCESS
		do
			--perform updates for each movable entities
			across
				board.movable_entities as entity
			loop
				if not entity.item.is_explorer then
					if entity.item.turns_left = 0 then
						if entity.item.is_planet and entity.item.location.has_star then
							check attached {PLANET} entity.item as p then
								p.set_orbit
								if entity.item.location.get_stationary.is_yellow_dwarf then
									life := gen.rchoose (1, 2)
									if life = 2 then
										p.set_life
									end
								end
							end--attached
						else
							if entity.item.location.has_wormhole and ( entity.item.is_malevolent
							or entity.item.is_benign) then
								entity.item.wormhole(board)
							else
								--choose direction 1-8
								--entity.item.move (dest: SECTOR)
							end
							--entity.item.check
							--if entitiy did not die
								--reproduce entity
								--behave entity
						end--either not a planet or a planet and no star in sector
					else
						entity.item.set_turns (entity.item.turns_left - 1)
					end
				end
			end
		end

end



