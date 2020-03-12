note
	description: "Summary description for {ENTITY_MOVABLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ENTITY_MOVABLE

inherit
	ENTITY_ALPHABET
		redefine
			is_equal
		end

create
	make

feature --attributes
	turn: INTEGER

feature -- Constructor

    make (a_char: CHARACTER; i: INTEGER)
        do
            item := a_char
            id := i
            turn := 0
        end


feature --query

	is_equal(other : ENTITY_MOVABLE): BOOLEAN
        do
            Result := current.item.is_equal (other.item) and
            			current.id.is_equal (other.id)
        end

feature --commands

	set_turn(i: INTEGER)
		do
			turn := i
		end


end


