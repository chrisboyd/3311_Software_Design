note
	description: "Deferred class for Star Entities, which have a luminosity value that provides fuel"
	author: "Chris Boyd : 216 869 356 : chris360"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	STAR

inherit

	ENTITY_STATIONARY
		redefine
			get_status
		end

feature --attributes

	luminosity: INTEGER
			--how much fuel does the star provide to passing entities

feature --Queries

	get_status: STRING
			--returns [id,item]->Luminosity:X
		do
			create Result.make_empty
			Result.append ("    [" + id.out + "," + item.out + "]->")
			Result.append ("Luminosity:" + luminosity.out)
		end

invariant
	allowable_symbols: item = '*' or item = 'Y'

end
