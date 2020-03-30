note
	description: "Summary description for {MALEVOLENT}."
	author: ""
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
			create death_msg.make_empty
			create move_info.make_empty
		end

feature --attributes
	repro_interval: INTEGER

feature --Commands

	reproduce: detachable ENTITY_MOVABLE
		do
			if repro_interval = 0 then
				if not location.is_full then
					Result := create {MALEVOLENT}.make (shared_info.movable_id, location)
					shared_info.inc_movable_id
					location.put (Result)
					repro_interval := 1
				end
			else
				repro_interval := repro_interval - 1
			end
		end

	--attack explorer, if present and not landed and no benign in sector
	--Explorer got lost in space - out of life support at Sector:X:Y
	behave
		local
			movables: SORTED_TWO_WAY_LIST[ENTITY_MOVABLE]
			msg: STRING
			exp_ind: INTEGER
			benign_present: BOOLEAN
		do
			movables := location.get_movables
			create msg.make_empty
			exp_ind := movables.index_of (create {EXPLORER}.make (0, location), 1)

			if exp_ind > 0 then
				check attached {EXPLORER} movables.i_th (exp_ind) as exp then
					if not exp.landed then
						across
							movables as entity
						loop
							if entity.item.is_benign then
								benign_present := True
							end
						end
						if not benign_present then
							movables.i_th (exp_ind).take_life
							if movables.i_th (exp_ind).is_dead then
								msg.append ("Explorer got lost in space - out of life support at Sector:")
								msg.append (location.print_sector)
								movables.i_th (exp_ind).set_death_msg (msg)
							end
						end
					end
				end
			end
		end

	get_name: STRING
		do
			create Result.make_from_string ("Malevolent")
		end

end
