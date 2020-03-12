note
	description: "Summary description for {ENTITY_STATIONARY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ENTITY_STATIONARY

inherit
	ENTITY_ALPHABET
		redefine
			is_equal
		end

create
	make

feature --attributes
	luminosity : INTEGER

feature -- Constructor

    make (a_char: CHARACTER; i: INTEGER)
        do
            item := a_char
            id := i
            luminosity := 0
        end


feature --query

	is_equal(other : ENTITY_STATIONARY): BOOLEAN
        do
            Result := current.item.is_equal (other.item)
        end

feature --commands

	set_luminosity(i: INTEGER)
		do
			luminosity := i
		end


end
