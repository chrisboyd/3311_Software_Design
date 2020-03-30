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
	move_info: STRING
	shared_info_access : SHARED_INFORMATION_ACCESS

	shared_info: SHARED_INFORMATION
		attribute
			Result:= shared_info_access.shared_info
		end

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

	--switch to deferred for death message
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
			Result := death_msg
			death_msg.wipe_out
		end

	set_death_msg(msg: STRING)
		do
			death_msg := msg
		end

	is_dead: BOOLEAN
		do
			Result := life = 0
		end

	take_life
		do
			if life > 0 then
				life := life -1
			end
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

	reproduce: detachable ENTITY_MOVABLE
		deferred
		end

	behave
		deferred
		end

	get_name: STRING
		deferred
		end


end
