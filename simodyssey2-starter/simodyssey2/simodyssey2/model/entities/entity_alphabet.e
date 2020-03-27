note
    description: "[
       Alphabet allowed to appear on the galaxy board.
    ]"
    author: "Kevin Banh"
    date: "April 30, 2019"
    revision: "1"

deferred class
    ENTITY_ALPHABET

--inherit
--    ANY
--        redefine
--            out,
--            is_equal
--        end

feature -- Attributes

    item: CHARACTER
    row: INTEGER
    col: INTEGER
    id: INTEGER


feature -- Query

--    out: STRING
--            -- Return string representation of alphabet.
--        do
--            Result := item.out
--        end

--    is_equal(other : ENTITY_ALPHABET): BOOLEAN
--        do
--            Result := current.item.is_equal (other.item) and current.id.is_equal (other.id)
--        end

    is_stationary: BOOLEAN
          -- Return if current item is stationary.
    	do
           if item = 'W' or item = 'Y' or item = '*' or item = 'O' then
           		Result := True
           end
        end

    is_movable: BOOLEAN
    	do
    		if item = 'E' or item = 'A' or item = 'P' or item = 'B' or item = 'M' or item = 'J' then
    			Result := True
    		end
    	end

   	is_planet: BOOLEAN
    	do
    		if item = 'P' then
    			Result := True
    		end
    	end

    is_explorer: BOOLEAN
    	do
    		if item = 'E' then
    			Result := True
    		end
    	end

    is_blackhole: BOOLEAN
    	do
    		if item = 'O' then
    			Result := True
    		end
    	end

    is_yellow_dwarf: BOOLEAN
    	do
    		if item = 'Y' then
    			Result := True
    		end
    	end

    is_blue_giant: BOOLEAN
    	do
    		if item = '*' then
    			Result := True
    		end
    	end

    is_wormhole: BOOLEAN
    	do
    		if item = 'W' then
    			Result := True
    		end
    	end

    is_benign: BOOLEAN
    	do
    		if item = 'B' then
    			Result := True
    		end
    	end

invariant
    allowable_symbols:
        item = 'E' or item = 'P' or item = 'A' or item = 'M' or  item = 'J' or item = 'O' or item = 'W' or item = 'Y' or item = '*' or item='B'
end
