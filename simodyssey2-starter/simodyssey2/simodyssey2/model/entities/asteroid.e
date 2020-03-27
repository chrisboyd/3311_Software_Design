note
	description: "Summary description for {ASTEROID}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ASTEROID

inherit
	ENTITY_BEHAVIOUR
		redefine
            out,
            is_equal
     	end

create
	make

feature --Initialization
	make(i: INTEGER)
		do
			item := 'A'
			id := i
			turns_left := gen.rchoose(0,2)
		end

feature --Commands
	behave
		do

		end

	check_post
		do

		end

	move(x: INTEGER; y: INTEGER)
		do
			row := x
			col := y
		end

feature --Queries

	out: STRING
		do
			Result := item.out
		end

	is_equal(other: ASTEROID): BOOLEAN
		do
			Result := current.item.is_equal (other.item) and
            			current.id.is_equal (other.id)
		end

end
