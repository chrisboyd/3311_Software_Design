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
			create deaths.make
			deaths.compare_objects
			create move_list.make_empty
			create status_msg.make_empty
		end

feature -- model attributes
	board : GALAXY
	play_mode: BOOLEAN
	test_mode: BOOLEAN
	error_msg: STRING
	game_state: INTEGER
	error_state: INTEGER
	shared_info_access : SHARED_INFORMATION_ACCESS
	move_list: STRING
	status_msg: STRING

	shared_info: SHARED_INFORMATION
		attribute
			Result:= shared_info_access.shared_info
		end

	deaths: LINKED_LIST [ENTITY_MOVABLE]
	aborted: BOOLEAN

feature -- model operations

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
			aborted := False
		end

	set_test(b: BOOLEAN)
		do
			test_mode := b
			game_state := game_state + 1
			error_state := 0
			aborted := False
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
			move_list.append (board.explorer.get_move_info + "%N")
			game_state := game_state + 1
			error_state := 0
			board.explorer.check_post_move
			--check for explorer death, does
			update_movables

		end

	wormhole_explorer
		do
			board.explorer.wormhole(board)
			game_state := game_state + 1
			error_state := 0
			board.explorer.check_post_move
			--check for explorer death
			update_movables
		end

	land_explorer
		local
			msg: STRING
		do
			msg := board.explorer.land
			if msg.is_empty then
				game_state := game_state + 1
				error_state := 0
				board.explorer.check_post_move
				if not board.explorer.found_life then
					update_movables
				end
			else
				set_error(msg)
			end
		end

	status
		do
			error_state := error_state + 1
			if not board.explorer.landed then
				status_msg.append ("  Explorer status report:Travelling at cruise speed at " +
					board.explorer.loc_out + "%N")
				status_msg.append ("  Life units left:" + board.explorer.life.out +
				", Fuel units left:" + board.explorer.fuel.out)
			else
				status_msg.append ("  Explorer status report:Stationary on planet surface at " +
					board.explorer.loc_out + "%N")
				status_msg.append ("  Life units left:3, Fuel units left:3")
			end
		end

	pass
		do
			game_state := game_state + 1
			error_state := 0
			update_movables
		end

	abort
		do
			aborted := True
			error_state := error_state + 1
			end_game
		end

	end_game
		do
			create board.make
			play_mode := False
			test_mode := False
			error_msg.wipe_out
			deaths.wipe_out
			move_list.wipe_out
			status_msg.wipe_out
		end

	game_ended
		do
			create board.make
			play_mode := False
			test_mode := False
			error_msg.wipe_out
			deaths.wipe_out
			move_list.wipe_out
			status_msg.wipe_out
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
				if not (play_mode or test_mode) and not aborted then
					Result.append ("  Welcome! Try test(3,5,7,15,30)")
				elseif aborted then
					Result.append ("  Mission aborted. Try test(3,5,7,15,30)")
				elseif not status_msg.is_empty then
					Result.append (status_msg)
				elseif board.explorer.found_life then
					Result.append ("  Tranquility base here - we've got a life!")
					end_game
				else
					if board.explorer.is_dead then
						Result.append ("  " + board.explorer.get_death_msg + "%N")
						Result.append ("  The game has ended. You can start a new game.%N")

					end
					Result.append ("  Movement:")
					if move_list.is_empty then
						Result.append("none%N")
					else
						Result.append ("%N" + move_list)
					end
					if test_mode then
						--sectors information
						Result.append ("  Sectors:%N")
						Result.append(board.get_sector_desc)
						--entity descriptiones
						Result.append ("  Descriptions:%N")
						Result.append (board.get_entity_desc)
						Result.append ("  Deaths This Turn:")
						if deaths.is_empty then
							Result.append ("none%N")
						else
							Result.append ("%N" + get_death_msgs)
						end
					end

					Result.append (board.out)
					if test_mode and board.explorer.is_dead then
						Result.append ("%N  " + board.explorer.get_death_msg + "%N")
						Result.append ("  The game has ended. You can start a new game.")
					end
					if board.explorer.is_dead then
						end_game
					end
				end

			end
			--wipe messages
			error_msg.wipe_out
			move_list.wipe_out
			deaths.wipe_out
			status_msg.wipe_out
			if board.explorer.is_dead then
				game_ended
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


	get_dest_coord (start: PAIR [INTEGER, INTEGER]; increment: PAIR [INTEGER, INTEGER]): PAIR [INTEGER, INTEGER]
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
			direction: INTEGER
			gen: RANDOM_GENERATOR_ACCESS
			dest: PAIR[INTEGER,INTEGER]
			dir_coord: PAIR[INTEGER, INTEGER]
			start: PAIR[INTEGER,INTEGER]
			reproduce: ENTITY_MOVABLE
			turns: INTEGER
			next_id: INTEGER
			entities_killed: LINKED_LIST [ENTITY_MOVABLE]
		do
			across
				board.movable_entities as entity
			loop
				if not entity.item.is_explorer then
					if entity.item.turns_left = 0 and not entity.item.is_dead then
						--special case for planet
						if entity.item.is_planet then
							--planet can't kill anything so don't need to check if
							--any items were returns by behave
							create entities_killed.make_from_iterable (entity.item.behave)
						else

							if entity.item.location.has_wormhole and ( entity.item.is_malevolent
							or entity.item.is_benign) then
								entity.item.wormhole(board)
							else
								--choose direction 1-8
								direction := gen.rchoose (1, 8)
								dir_coord := map_direction(direction)
								start := create {PAIR[INTEGER,INTEGER]}.make (entity.item.location.row, entity.item.location.column)
								dest := get_dest_coord(start, dir_coord)
								entity.item.move (board.grid[dest.first, dest.second])
							end
							entity.item.check_post_move
							if not entity.item.is_dead then
								next_id := board.movable_id
								reproduce := entity.item.reproduce (next_id)
								if attached reproduce as r then
									board.movable_entities.extend (r)
									board.inc_movable_id
								end
								create entities_killed.make_from_iterable (entity.item.behave)
								if not entities_killed.is_empty then
									deaths.finish
									deaths.merge_right (entities_killed)
								end

							else
								deaths.extend (entity.item)
							end

							move_list.append (entity.item.get_move_info + "%N")

						end--either not a planet or a planet and no star in sector
					elseif entity.item.is_dead and not deaths.has (entity.item)then
						deaths.extend (entity.item)
					else
						entity.item.set_turns (entity.item.turns_left - 1)
					end
				end-- end of if not explorer
			end--end of across
			remove_dead_entities
		end--end of do

		remove_dead_entities
			do
				from
					board.movable_entities.start
				until
					board.movable_entities.exhausted
				loop
					if board.movable_entities.item.is_dead then
						board.movable_entities.remove
					else
						board.movable_entities.forth
					end
				end
			end

		get_death_msgs: STRING
			do
				create Result.make_empty
				across
					deaths as entity
				loop
					Result.append (entity.item.get_status + ",%N")
					Result.append ("      " + entity.item.death_msg + "%N")
				end
			end

end




