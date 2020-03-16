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

feature {none} --attributes
	turn: INTEGER
	fuel: INTEGER
	landed: BOOLEAN
	attach: BOOLEAN
	support_life: BOOLEAN
	visited: BOOLEAN
	set_life: BOOLEAN
feature -- Constructor

    make (a_char: CHARACTER; i: INTEGER)
        do
            item := a_char
            id := i
            turn := 0
            landed := False
            row := 0
            col := 0
			attach := False
			visited := False
			set_life := False

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
		require
			amount >= 0
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

	get_fuel: INTEGER
		do
			Result := fuel
		end

	get_turns : INTEGER
		do
			Result := turn
		end

	attach_star
		do
			attach := True
		end

	is_attached: BOOLEAN
		do
			Result := attach
		end

	can_support_life: BOOLEAN
		do
			Result := support_life
		end

	set_support_life (life: BOOLEAN)
		do
			support_life := life
			set_life := True
		end

	is_visited: BOOLEAN
		do
			Result := visited
		end

	visit
		do
			visited := True
		end

	set_land(land: BOOLEAN)
		do
			landed := land
		end

	has_set_life: BOOLEAN
		do
			Result := set_life
		end

end


