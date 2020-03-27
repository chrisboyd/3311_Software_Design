note
	description: "Summary description for {MALEVOLENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MALEVOLENT

inherit
	ENTITY_REPRODUCE
		redefine
            out,
            is_equal
        end

create
	make

feature {NONE} -- Initialization

	make(i: INTEGER)
			-- Initialization for `Current'.
		do
			item := 'M'
			id := i
			fuel := 3
			repro_interval := 1
			turns_left := gen.rchoose(0,2)
		end

feature --Commands
	move(x: INTEGER; y: INTEGER)
		do
			row := x
			col := y
		end

	behave
		do

		end

	check_post
		do

		end

feature --Queries

	out: STRING
		do
			Result := item.out
		end

	is_equal(other: MALEVOLENT): BOOLEAN
		do
			Result := current.item.is_equal (other.item) and
            			current.id.is_equal (other.id)
		end

end
