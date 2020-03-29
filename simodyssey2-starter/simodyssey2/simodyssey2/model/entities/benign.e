note
	description: "Summary description for {BENIGN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BENIGN

inherit
	ENTITY_MOVABLE

create
	make

feature -- Initialization

	make(i: INTEGER; loc: SECTOR)
			-- Initialization for `Current'.
		do
			item := 'B'
			id := i
			fuel := 3
			repro_interval := 1
			location := loc
			life := 1
			create death_msg.make_empty
		end

feature --attributes
	repro_interval: INTEGER

feature --Commands

	reproduce: detachable ENTITY_MOVABLE
		do
			if repro_interval = 0 then
				if not location.is_full then
					Result := create {BENIGN}.make (shared_info.movable_id, location)
					shared_info.inc_movable_id
					location.put (Result)
					repro_interval := 1
				end
			else
				repro_interval := repro_interval - 1
			end
		end

	--destroy all malevolent in sector from low to high id
	--Malevolent got destroyed by benign (id: Z) at Sector:X:Y
	behave
		local
			movables: SORTED_TWO_WAY_LIST[ENTITY_MOVABLE]
			msg: STRING
		do
			movables := location.get_movables
			create msg.make_empty
			across
				movables as entity
			loop
				if entity.item.is_malevolent then
					msg.append ("Malevolent got destroyed by benign (id: " + id.out)
					msg.append (") at Sector:" + location.print_sector)
					entity.item.kill
					entity.item.set_death_msg (msg)
					location.remove (entity.item)
				end
				msg.wipe_out
			end
		end

	get_name: STRING
		do
			create Result.make_from_string ("Benign")
		end

end
