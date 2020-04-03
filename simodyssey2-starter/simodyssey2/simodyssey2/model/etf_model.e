note
	description: "Primary business logic of SimOdyssey2 Boardgame"
	author: "Chris Boyd : 216 869 356 : chris360"
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

	board: GALAXY
			--access to the board that contains all sectors and entities in the game

	play_mode: BOOLEAN
			--did the user start the game in play mode

	test_mode: BOOLEAN
			--did the user start the game in test mode, provides additional information
			--about what happens each turn

	error_msg: STRING
			--set a message with regards to invalid command received

	game_state: INTEGER
			--the number of valid turns that have passed in the game

	error_state: INTEGER
			--the number of invalid commands that have been processed since
			--the last valid turn

	shared_info_access: SHARED_INFORMATION_ACCESS
			--ac

	shared_info: SHARED_INFORMATION
		attribute
			Result := shared_info_access.shared_info
		end

	move_list: STRING

	status_msg: STRING



	deaths: LINKED_LIST [ENTITY_MOVABLE]

	aborted: BOOLEAN

feature -- model operations

	reset
			-- Reset model state.
		do
			make
		end

	set_play
			--Turn on play mode, increment the current game state
			--and reset the error state
		require
			not_in_game: not (test_mode or play_mode)
		do
			play_mode := True
			game_state := game_state + 1
			error_state := 0
			aborted := False
		ensure
			game_state_updated: game_state = old game_state + 1
			set_play_mode: play_mode
		end

	set_test
			--Turn on test mode which provides the user with additional
			--information as to what each entity is doing every turn.
			--Increment the game state and reset the error state
		require
			not_in_game: not (test_mode or play_mode)
		do
			test_mode := True
			game_state := game_state + 1
			error_state := 0
			aborted := False
		ensure
			game_state_updated: game_state = old game_state + 1
			set_test_mode: test_mode
		end

	set_error (msg: STRING)
			--User command triggered an error, increment error state
		do
			error_msg := msg
			error_state := error_state + 1
		ensure
			error_state_updated: error_state = old error_state + 1
		end

	initialize_game (a_thresh: INTEGER; j_thresh: INTEGER; m_thresh: INTEGER; b_thresh: INTEGER; p_thresh: INTEGER)
		require
			valid_threshold: 0 < a_thresh and a_thresh <= j_thresh and j_thresh <= m_thresh and m_thresh <= b_thresh and b_thresh <= p_thresh and p_thresh <= 101
			--Place all movable and stationary entities the game board
			--according to thresholds defined as input
		do
				--initialize board with all movable entities
			board.set_movable_items (a_thresh, j_thresh, m_thresh, b_thresh, p_thresh)
				--initialize board with all stationary entities
				--do separate from movable due to random number generator
			board.set_stationary_items
		end

	move_explorer (dest_row: INTEGER; dest_col: INTEGER)
			--move the explorer to the first available quadrant in
			--[dest_row, dest_col]
			--increment game state and reset error state
			--complete a turn of all movable entities in the game
		require
			in_game: play_mode or test_mode
			not_landed: not board.explorer.landed
		do
			board.explorer.move (board.get_sector (dest_row, dest_col))
			move_list.append (board.explorer.get_move_info + "%N")
			game_state := game_state + 1
			error_state := 0
			board.explorer.check_post_move
			update_movables
		ensure
			game_state_updated: game_state = old game_state + 1
		end

	wormhole_explorer
			--send the explorer through the wormhole to a random location
			--increment game state and reset error state
			--complete a turn of all movable entities in the game
		require
			in_game: play_mode or test_mode
		do
			board.explorer.wormhole (board)
			move_list.append (board.explorer.get_move_info + "%N")
			game_state := game_state + 1
			error_state := 0
			board.explorer.check_post_move
			update_movables
		ensure
			game_state_updated: game_state = old game_state + 1
		end

	land_explorer
			--land the explorer at the first unvisited plane in the
			--sector and check to see if life was found
			--increment game state and reset error state
			--complete a turn for all movable entities if no life found
		require
			not_landed: not board.explorer.landed
			in_game: play_mode or test_mode
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
				set_error (msg)
			end
		end

	liftoff_explorer
			--lift the explorer back into space in the current sector
			--increment game state and reset error state
			--complete a turn for all movable entities
		require
			landed: board.explorer.landed
			in_game: play_mode or test_mode
		do
			board.explorer.liftoff
			game_state := game_state + 1
			error_state := 0
			update_movables
		ensure
			game_state_updated: game_state = old game_state + 1
		end

	status
			--update the status of the explorer, including
			--if explorer is flying, landed and their current life, fuel and location
			--counts as an error state as it does not cause a turn of all the
			--movable entities to occur
		require
			in_game: play_mode or test_mode
		do
			error_state := error_state + 1
			if not board.explorer.landed then
				status_msg.append ("  Explorer status report:Travelling at cruise speed at " + board.explorer.loc_out + "%N")
				status_msg.append ("  Life units left:" + board.explorer.life.out + ", Fuel units left:" + board.explorer.fuel.out)
			else
				status_msg.append ("  Explorer status report:Stationary on planet surface at " + board.explorer.loc_out + "%N")
				status_msg.append ("  Life units left:3, Fuel units left:3")
			end
		ensure
			error_state_updated: error_state = old error_state + 1
		end

	pass
			--the explorer does not move or act this turn
			--increments the game state and resets the error state
			--causes a turn for all movable entities to occur
		require
			in_game: play_mode or test_mode
		do
			game_state := game_state + 1
			error_state := 0
			update_movables
		ensure
			game_state_updated: game_state = old game_state + 1
		end

	abort
			--quit the current game and remove all pieces from the board
			--increment the error state
		require
			in_game: play_mode or test_mode
		do
			aborted := True
			error_state := error_state + 1
			end_game
		ensure
			error_state_updated: error_state = old error_state + 1
			game_ended: not (play_mode or test_mode)
		end

feature -- queries

	out: STRING
			--Output the state of the game to the user
		local
			victory: BOOLEAN
		do
			create Result.make_empty
			Result.append ("  state:" + game_state.out + "." + error_state.out + ",")
			if play_mode then
				Result.append (" mode:play,")
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
				else
					if board.explorer.is_dead then
						Result.append ("  " + board.explorer.get_entity_msg + "%N")
						Result.append ("  The game has ended. You can start a new game.%N")
					elseif board.explorer.found_life then
						Result.append ("  " + board.explorer.get_entity_msg)
						victory := True
					elseif not board.explorer.entity_msg.is_empty then
						Result.append ("  " + board.explorer.get_entity_msg + "%N")
					end
					if not victory then
						Result.append ("  Movement:")
						if move_list.is_empty then
							Result.append ("none%N")
						else
							Result.append ("%N" + move_list)
						end
						if test_mode then
								--sectors information
							Result.append ("  Sectors:%N")
							Result.append (board.get_sector_desc)
								--entity descriptiones
							Result.append ("  Descriptions:%N")
							Result.append (board.get_entity_desc)
								--deaths this turn
							Result.append ("  Deaths This Turn:")
							if deaths.is_empty then
								Result.append ("none%N")
							else
								Result.append ("%N" + get_death_msgs)
							end
						end

							--output the game board
						Result.append (board.out)
						if test_mode and board.explorer.is_dead then
							Result.append ("%N  " + board.explorer.get_entity_msg + "%N")
							Result.append ("  The game has ended. You can start a new game.")
						end
					end
				end
			end
				--wipe messages
			error_msg.wipe_out
			move_list.wipe_out
			deaths.wipe_out
			status_msg.wipe_out
			board.explorer.entity_msg.wipe_out
			if board.explorer.is_dead or victory then
				end_game
			end
		end

	get_death_msgs: STRING
			--Returns a list of all of the entities that died during
			--the turn
		do
			create Result.make_empty
			across
				deaths as entity
			loop
				Result.append (entity.item.get_status + ",%N")
				Result.append ("      " + entity.item.entity_msg + "%N")
			end
		end

feature --operations support

	map_direction (direction: INTEGER): PAIR [INTEGER, INTEGER]
			--Map a given single integer value [1,8] to a increment
			--representing a direction change from [0,0].
			--Start with 1 = N, 2 = NE until 8 = NW
		require
			valid_direction: direction >= 1 and direction <= 8
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
		ensure
			valid_coord: (Result.first <= shared_info.number_rows) and (Result.second <= shared_info.number_columns)
		end

	get_dest_coord (start: PAIR [INTEGER, INTEGER]; increment: PAIR [INTEGER, INTEGER]): PAIR [INTEGER, INTEGER]
			--Given a start coordinate as [x,y] and the direction to move as [x_inc,y_inc],
			--determine the destinattion of [x + x_inc, y + y_inc]. Wraps around the edges
			--of the board in all directions
		require
			valid_start: (start.first <= shared_info.number_rows) and (start.second <= shared_info.number_columns)
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
		ensure
			valid_dest: (Result.first <= shared_info.number_rows) and (Result.second <= shared_info.number_columns)
		end

feature {NONE} --Internal operations

	end_game
			--Reset the board to base configuration of only the
			--explorer at [1,1] and the blackhole at [3,3].
			--Happens after the user aborts or the explorer lands
			--on a planet with life.
		do
			create board.make
			play_mode := False
			test_mode := False
			error_msg.wipe_out
			deaths.wipe_out
			move_list.wipe_out
			status_msg.wipe_out
		end

	update_movables
			--Completes a turn for each movable entity in the game.
			--At the end all newly produced entities and all entities killed during the
			--current turn are removed from the list of movable entities
		local
			direction: INTEGER
			gen: RANDOM_GENERATOR_ACCESS
			dest: PAIR [INTEGER, INTEGER]
			dir_coord: PAIR [INTEGER, INTEGER]
			start: PAIR [INTEGER, INTEGER]
			reproduce: ENTITY_MOVABLE
			next_id: INTEGER
			entities_killed: LINKED_LIST [ENTITY_MOVABLE]
			created_entities: SORTED_TWO_WAY_LIST [ENTITY_MOVABLE]
		do
			create created_entities.make
			created_entities.compare_objects
			across
				board.movable_entities as entity
			loop
				if not entity.item.is_explorer then
					if entity.item.turns_left = 0 and not entity.item.is_dead then
							--special case for planet
						if entity.item.is_planet and entity.item.location.has_star then
								--planet can't kill anything so don't need to check if
								--any items were returns by behave
							create entities_killed.make_from_iterable (entity.item.behave)
						else
								--malevolent and benign entities always take the wormhole, if present
							if entity.item.location.has_wormhole and (entity.item.is_malevolent or entity.item.is_benign) then
								entity.item.wormhole (board)
							else
									--choose direction 1-8
								direction := gen.rchoose (1, 8)
								dir_coord := map_direction (direction)
								start := create {PAIR [INTEGER, INTEGER]}.make (entity.item.location.row, entity.item.location.column)
								dest := get_dest_coord (start, dir_coord)
									--entity.item.move (board.grid[dest.first, dest.second])
								entity.item.move (board.get_sector (dest.first, dest.second))
							end
								--post move, check for refuel, out of fuel, devoured by blackhole
							entity.item.check_post_move
							if not entity.item.is_dead then
								next_id := board.movable_id
								reproduce := entity.item.reproduce (next_id)
								if attached reproduce as r then
										--board.movable_entities.extend (r)
										--add created entities to a separate list, then add
										--all of the new entities to the movable list AFTER
										--update_movables is done so they don't act in turn they are
										--created
									created_entities.extend (r)
									board.inc_movable_id
								end
									--add all entities that current entity killed during its behave
								create entities_killed.make_from_iterable (entity.item.behave)
								if not entities_killed.is_empty then
									deaths.finish
									deaths.merge_right (entities_killed)
								end

									--entity died during the turn
							else
								deaths.extend (entity.item)
							end
								--add current entities move information to the list
								--even if it did not move during the turn
							move_list.append (entity.item.get_move_info + "%N")
						end --either not a planet or a planet and no star in sector
					elseif entity.item.is_dead and not deaths.has (entity.item) then
						deaths.extend (entity.item)
							--remove a turn (entity did not act this round)
					else
						entity.item.set_turns (entity.item.turns_left - 1)
					end
				end -- end of if not explorer
			end --end of across
				--add newly created entities to the list of all alive movable entities
			add_produced_entities (created_entities)
				--remove any entities that died this turn
			remove_dead_entities
		end --end of do

	add_produced_entities (created: SORTED_TWO_WAY_LIST [ENTITY_MOVABLE])
			--Add all of the newly produced entities in the last turn to
			--the list of all movable entities
		do
			across
				created as to_add
			loop
				board.movable_entities.extend (to_add.item)
			end
		ensure
			correct_num_added: board.movable_entities.count = old (board.movable_entities.count + created.count)
			movable_contains_added: across created as c all board.movable_entities.has (c.item) end
		end

	remove_dead_entities
			--Remove all entities that died during the turn
			--from the list of all movable entities
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
		ensure
			no_dead: across board.movable_entities as entity all not entity.item.is_dead end
		end

end
