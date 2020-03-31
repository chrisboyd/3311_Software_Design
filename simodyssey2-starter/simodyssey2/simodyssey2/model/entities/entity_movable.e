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
	entity_msg: STRING
	move_info: STRING
	shared_info_access : SHARED_INFORMATION_ACCESS

	shared_info: SHARED_INFORMATION
		attribute
			Result:= shared_info_access.shared_info
		end
	gen: RANDOM_GENERATOR_ACCESS

feature --commands
	set_turns(i: INTEGER)
		do
			turns_left := i
		end

	move(dest: SECTOR)
		do
			move_info.wipe_out
			move_info.append ("    " + Current.id_out + ":" + Current.loc_out)
			if not dest.is_full then
				dest.put (Current)
				location.remove (Current)
				location := dest
				move_info.append ("->" + Current.loc_out)
				--use fuel planets and asteroids don't need this
				fuel := fuel - 1
			end


		end

	wormhole(board: GALAXY)
		local
			added: BOOLEAN
			temp_row: INTEGER
			temp_col: INTEGER
		do
			move_info.wipe_out
			move_info.append ("    " + Current.id_out + ":" + Current.loc_out)
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
			move_info.append ("->" + Current.loc_out)
		end

	get_entity_msg: STRING
		do
			Result := entity_msg
		end

	set_entity_msg(msg: STRING)
		do
			entity_msg := msg
		end

	is_dead: BOOLEAN
		do
			Result := life = 0
		end

	take_life
		require
			life > 0
		do
			life := life -1
		end
	kill
		do
			life := 0
		end

	get_move_info:STRING
		do
			Result := move_info
		end

feature --deferred command

	reproduce(next_id: INTEGER): detachable ENTITY_MOVABLE
		deferred
		end

	behave: LINKED_LIST [ENTITY_MOVABLE]
		deferred
		end

	get_name: STRING
		deferred
		end

	check_post_move
		deferred
		end

	get_status: STRING
		deferred
		end


end
