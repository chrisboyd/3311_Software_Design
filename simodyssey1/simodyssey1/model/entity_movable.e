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

feature{none} --attributes
	turn: INTEGER
	fuel: INTEGER
	landed: BOOLEAN
feature -- Constructor

    make (a_char: CHARACTER; i: INTEGER)
        do
            item := a_char
            id := i
            turn := 0
            landed := False
            row := 0
            col := 0

            if a_char = 'E' then
            	fuel := 3
            else
            	fuel := 0
            end
        end


feature --query

	is_equal(other : ENTITY_MOVABLE): BOOLEAN
        do
            Result := current.item.is_equal (other.item) and
            			current.id.is_equal (other.id)
        end

    is_landed: BOOLEAN
    	do
    		Result := landed
    	end

	land
		do
			landed := True
		end
feature --commands

	set_turn (i: INTEGER)
		do
			turn := i
		end

	use_fuel
		do
			if fuel >= 1 then
				fuel := fuel - 1
			end
		end
	add_fuel (amount: INTEGER)
		do
			fuel := fuel + amount
			if fuel > 3 then
				fuel := 3
			end

		ensure
			fuel <= 3
		end

	fuel_empty : BOOLEAN
		do
			Result := fuel = 0
		end

end


