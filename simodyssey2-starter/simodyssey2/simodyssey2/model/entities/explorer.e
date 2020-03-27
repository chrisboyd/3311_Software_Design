note
	description: "Summary description for {EXPLORER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXPLORER

inherit
	ENTITY_MOVABLE
		redefine
            out,
            is_equal
        end

create
	make

feature -- Initialization

	make(i: INTEGER)
			-- Initialization for `Current'.
		do
			item := 'E'
			id := i
			life := 3
			fuel := 3
			landed := False
		end

feature --Attributes
	life: INTEGER
	fuel: INTEGER
	landed: BOOLEAN

feature --Commands
	move(x: INTEGER; y: INTEGER)
		do
			row := x
			col := y
		end

	land
		require
			not landed
		do
			landed := True
		end

	liftoff
		require
			landed
		do
			landed := False
		end

feature --queries
	out: STRING
		do
			Result := item.out
		end

	is_equal(other: EXPLORER): BOOLEAN
		do
			Result := current.item.is_equal (other.item) and
            			current.id.is_equal (other.id)
		end

end
