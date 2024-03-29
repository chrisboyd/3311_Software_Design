note
	description: "Asteroids randomly move about the galaxy destroying"
	author: "Chris Boyd : 216 869 356 : chris360"
	date: "$Date$"
	revision: "$Revision$"

class
	ASTEROID

inherit

	ENTITY_MOVABLE

create
	make

feature --Initialization

	make (i: INTEGER; loc: SECTOR)
		do
			item := 'A'
			location := loc
			life := 1
			id := i
			create entity_msg.make_empty
			create move_info.make_empty
		end

feature --Commands

	check_post_move
			--Checks if asteroids new location contains a blackhole, which will
			--kill the asteroid
		do
			if location.has_blackhole then
				life := 0
				entity_msg.append ("Asteroid got devoured by blackhole (id: -1) at Sector:3:3")
				location.remove (Current)
			end
		end

	reproduce (next_id: INTEGER): detachable ENTITY_MOVABLE
			--Asteroids do not reproduce
		do
		end

	behave: LINKED_LIST [ENTITY_MOVABLE]
			--seeks out movable_entities other than asteroids
			--and planets and destroys in ascending id order
			--entity got destroyed by asteroid (id: Z) at Sector:X:Y
		local
			movables: SORTED_TWO_WAY_LIST [ENTITY_MOVABLE]
			msg: STRING
		do
			create Result.make
			Result.compare_objects
			movables := location.get_movables
			create msg.make_empty
			across
				movables as entity
			loop
				if not (entity.item.is_asteroid or entity.item.is_planet) then
					if entity.item.is_explorer then
						check attached {EXPLORER} entity.item as exp then
							if not exp.landed then
								entity.item.kill
								move_info.append ("%N      destroyed " + entity.item.id_out + " at " + entity.item.loc_out)
								msg.append (entity.item.get_name + " got destroyed by asteroid (id: ")
								msg.append (id.out + ") at Sector:" + location.out)
								location.remove (entity.item)
								entity.item.set_entity_msg (msg)
								Result.extend (entity.item)
							end
						end
					else
						entity.item.kill
						move_info.append ("%N      destroyed " + entity.item.id_out + " at " + entity.item.loc_out)
						msg.append (entity.item.get_name + " got destroyed by asteroid (id: ")
						msg.append (id.out + ") at Sector:" + location.out)
						location.remove (entity.item)
						entity.item.set_entity_msg (msg)
						Result.extend (entity.item)
					end
				end
				create msg.make_empty
			end
			turns_left := gen.rchoose (0, 2)
		end

feature --Queries

	get_name: STRING
			--Return string represation of this class
		do
			create Result.make_from_string ("Asteroid")
		end

	get_status: STRING
			--Returns current status of the asteroid for
			--outputing in test mode [id,A]->turns_left:X
		do
			create Result.make_empty
			Result.append ("    " + id_out + "->turns_left:")
			if life = 0 then
				Result.append ("N/A")
			else
				Result.append (turns_left.out)
			end
		end

invariant
	allowable_symbols: item = 'A'

end
