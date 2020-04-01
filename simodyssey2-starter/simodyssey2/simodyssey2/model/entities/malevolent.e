note
	description: "Evil entity that seeks out and attacks"
	author: "Chris Boyd : 216 869 356 : chris360"
	date: "$Date$"
	revision: "$Revision$"

class
	MALEVOLENT

inherit
	ENTITY_MOVABLE

create
	make

feature --Initialization

	make(i: INTEGER; loc: SECTOR)
			-- Initialization for `Current'.
		do
			item := 'M'
			id := i
			fuel := 3
			repro_interval := 1
			location := loc
			life := 1
			create entity_msg.make_empty
			create move_info.make_empty
		end

feature --attributes
	repro_interval: INTEGER

feature --Commands

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
				entity_msg.append ("Malevolent got lost in space - out of fuel at Sector:" + location.out)
			elseif location.has_blackhole then
				life := 0
				entity_msg.append ("Malevolent got devoured by blackhole (id: -1) at Sector:3:3")
			end

			if fuel = 0 and entity_msg.is_empty then
				life := 0
				entity_msg.append ("Malevolent got lost in space - out of fuel at Sector:" + location.out)
			end

			if life = 0 then
				location.remove (Current)
			end

		end

	reproduce(next_id: INTEGER): detachable ENTITY_MOVABLE
		local
			temp: MALEVOLENT
			turns: INTEGER
		do
			if repro_interval = 0 then
				if not location.is_full then
					create temp.make (next_id, location)
					location.put (temp)
					turns := gen.rchoose (0, 2)
					temp.set_turns (turns)
					move_info.append ("%N      reproduced " + temp.id_out + " at " + temp.loc_out)
					repro_interval := 1
					Result := temp
				end
			else
				repro_interval := repro_interval - 1
			end
		end


	behave: LINKED_LIST [ENTITY_MOVABLE]
		--attack explorer, if present and not landed and no benign in sector
		--Explorer got lost in space - out of life support at Sector:X:Y
		local
			movables: SORTED_TWO_WAY_LIST[ENTITY_MOVABLE]
			msg: STRING
		do
			create Result.make
			Result.compare_objects
			--double check this all
			movables := location.get_movables
			create msg.make_empty

			across
				movables as entity
			loop
				if entity.item.is_explorer then
					check attached {EXPLORER} entity.item as exp then
						if not (exp.landed and location.has_benign) then
							exp.take_life
							move_info.append ("%N      attacked " + exp.id_out + " at " + exp.loc_out)
							if exp.is_dead then
								msg.append ("Explorer got lost in space - out of life support at Sector:")
								msg.append (location.print_sector)
								exp.set_entity_msg (msg)
								location.remove (exp)
								Result.extend (exp)
							end
						end
					end
				end
			end
			turns_left := gen.rchoose (0, 2)
		end

feature --Queries

	get_name: STRING
		--Return string represation of this class
		do
			create Result.make_from_string ("Malevolent")
		end

	get_status: STRING
		--Returns current status of the benign for
		--outputing in test mode
		--[id,M]->fuel:fF/3, actions_left_until_reproduction:A/1, turns_left:X
		do
			create Result.make_empty
			Result.append ("    " + id_out + "->fuel:" + fuel.out + "/3, actions_left_until_reproduction:")
			Result.append (repro_interval.out + "/1, turns_left:")
			if life = 0 then
				Result.append("N/A")
			else
				Result.append(turns_left.out)
			end
		end

invariant
    allowable_symbols:
        item = 'M'

end
