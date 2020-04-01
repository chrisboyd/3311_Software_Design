note
	description: "Summary description for {STAR}."
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

feature --Queries

	get_status: STRING
		do
			create Result.make_empty
			Result.append ("    [" + id.out + "," + item.out + "]->")
			Result.append ("Luminosity:" + luminosity.out)

		end

invariant
    allowable_symbols:
        item = '*' or item = 'Y'

end
