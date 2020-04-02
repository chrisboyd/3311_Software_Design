note
	description: "Provides base interface for all movable entities"
	author: "Chris Boyd : 216 869 356 : chris360"
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

	shared_info_access: SHARED_INFORMATION_ACCESS

	shared_info: SHARED_INFORMATION
		attribute
			Result := shared_info_access.shared_info
		end

	gen: RANDOM_GENERATOR_ACCESS

feature --commands

	set_turns (i: INTEGER)
			--Set number of turns for the entity
		do
			turns_left := i
		end

	move (dest: SECTOR)
			--Move the entity to the destination sector. If destination sector
			--is full does nothing
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

	wormhole (board: GALAXY)
			--Sends the entity through the wormhole which randomly selections
			--a destionation sector on the board until a non-full sector is found.
			--Can send the entity back to the start location.
		local
			added: BOOLEAN
			temp_row: INTEGER
			temp_col: INTEGER
			start: STRING
		do
			move_info.wipe_out
			move_info.append ("    " + Current.id_out + ":" + Current.loc_out)
			start := Current.loc_out
			from
				added := False
			until
				added
			loop
				temp_row := gen.rchoose (1, 5)
				temp_col := gen.rchoose (1, 5)
				if not board.get_sector (temp_row, temp_col).is_full then
					board.get_sector (location.row, location.column).remove (Current)
					board.get_sector (temp_row, temp_col).put (Current)
					location := board.get_sector (temp_row, temp_col)
					added := True
				end
			end
			if not (start.is_equal (Current.loc_out)) then
				move_info.append ("->" + Current.loc_out)
			end
		end

	get_entity_msg: STRING
			--Return the entity's status message, likely set in the event
			--of the entity being killed by something.
		do
			Result := entity_msg
		end

	set_entity_msg (msg: STRING)
			--Set the entity's status message, used by other entities
			--when interacting with this entity
		do
			entity_msg := msg
		end

	is_dead: BOOLEAN
			--Is the entity out of life?
		do
			Result := life = 0
		end

	take_life
			--Take a life from the current entity
		require
			life > 0
		do
			life := life - 1
		end

	kill
			--kill the entity
		do
			life := 0
		end

	get_move_info: STRING
			--return the string of move entity performed during current turn
		do
			Result := move_info
		end

feature --deferred command

	reproduce (next_id: INTEGER): detachable ENTITY_MOVABLE
			--if reproduce timer is up, create a new entity of same type in
			--current location (if not full)
		deferred
		end

	behave: LINKED_LIST [ENTITY_MOVABLE]
			--perform inherited class behaviour
		deferred
		end

	get_name: STRING
			--get string representation of inherited class name
		deferred
		end

	check_post_move
			--perform inherited class post move actions
		deferred
		end

	get_status: STRING
			--return status string of inherited class
		deferred
		end

invariant
	allowable_symbols: item = 'E' or item = 'P' or item = 'A' or item = 'M' or item = 'J' or item = 'W' or item = 'B'

end
