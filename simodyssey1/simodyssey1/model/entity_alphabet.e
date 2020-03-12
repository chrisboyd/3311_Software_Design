note
    description: "[
       Alphabet allowed to appear on the galaxy board.
    ]"
    author: "Kevin Banh"
    date: "April 30, 2019"
    revision: "1"

deferred class
    ENTITY_ALPHABET

inherit
    ANY
        redefine
            out,
            is_equal
        end


feature -- Attributes

    item: CHARACTER
	id: INTEGER

feature -- Query

    out: STRING
            -- Return string representation of alphabet.
        do
            Result := item.out
        end

    out_id: STRING
    	do
    		create Result.make_empty
    		Result.append ("[")
    		Result.append_integer (id)
    		Result.append ("," + item.out + "]")
    	end

    is_equal(other : ENTITY_ALPHABET): BOOLEAN
        do
            Result := current.item.is_equal (other.item) and
            			current.id.is_equal (other.id)
        end

    is_stationary: BOOLEAN
          -- Return if current item is stationary.
    	do
           if item = 'W' or item = 'Y' or item = '*' or item = 'O' then
           		Result := True
           else
           		Result := False
           end
        end

    is_movable: BOOLEAN
    	do
    		if item = 'E' or item = 'P' then
    			Result := True
    		else
    			Result := False
    		end
    	end

    is_planet(ent: ENTITY_ALPHABET): BOOLEAN
    	do
    		if item = 'P' then
    			Result := True
    		else
    			Result := False
    		end
    	end

    is_explorer(ent: ENTITY_ALPHABET): BOOLEAN
    	do
    		if item = 'E' then
    			Result := True
    		else
    			Result := False
    		end
    	end

    is_blackole(ent: ENTITY_ALPHABET): BOOLEAN
    	do
    		if item = 'O' then
    			Result := True
    		else
    			Result := False
    		end
    	end

    is_yellow_dwarf(ent: ENTITY_ALPHABET): BOOLEAN
    	do
    		if item = 'Y' then
    			Result := True
    		else
    			Result := False
    		end
    	end

    is_blue_giant(ent: ENTITY_ALPHABET): BOOLEAN
    	do
    		if item = '*' then
    			Result := True
    		else
    			Result := False
    		end
    	end

    is_wormhole(ent: ENTITY_ALPHABET): BOOLEAN
    	do
    		if item = 'W' then
    			Result := True
    		else
    			Result := False
    		end
    	end

invariant
    allowable_symbols:
        item = 'E' or item = 'P' or item = 'O' or item = 'W' or item = 'Y' or item = '*'
end
