note
	description: "Summary description for {ASTEROID}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ASTEROID

inherit
	ENTITY_MOVABLE
		redefine
			check_post_move
		end

create
	make


feature --Initialization
	make(i: INTEGER; loc: SECTOR)
		do
			item := 'A'
			location := loc
			life := 1
			create death_msg.make_empty
			create move_info.make_empty
		end


feature --Commands

	check_post_move
		do
			if location.has_blackhole then
				life := 0
			end
		end

	reproduce: detachable ENTITY_MOVABLE
		do
		end

	--seeks out other movable_entities other than other asteroids
	--and planets and destroys in ascending id order
	--entity got destroyed by asteroid (id: Z) at Sector:X:Y
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
				if not (entity.item.is_asteroid or entity.item.is_planet) then
					entity.item.kill
					msg.append (entity.item.get_name + " got destroyed by asteroid (id: ")
					msg.append (id.out + ") at Sector:" + location.print_sector)
				end
			end
		end

	get_name: STRING
		do
			create Result.make_from_string ("Asteroid")
		end

end
