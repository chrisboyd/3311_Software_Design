note
	description: "Summary description for {MY_BOOK_CURSOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

-- uses jackies video https://www.youtube.com/watch?v=_0ObNUtKsXo @ 45 min
class
	MY_BOOK_CURSOR[G]
inherit
	ITERATION_CURSOR[TUPLE[STRING, G]]


create
	make

feature {NONE} -- Attributes

	names: ARRAY[STRING]
	records: ARRAY[G]
	i: INTEGER

feature -- Commands
	make (ns: ARRAY[STRING]; rs: ARRAY[G])
		do
			names := ns
			records := rs
			i := names.lower
		end

feature -- Cursor features

	item: TUPLE[STRING, G]
		local
			name: STRING
			rec: G
		do
			name:= names[i]
			rec:= records[i]
			create Result
			Result := [name, rec]
		end

	after: BOOLEAN
	--is there no more items in arrays
		do
			Result := i > names.upper
		end

	forth
	--move cursor position one to the right
		do
			i := i + 1
		end

invariant
	consistent_arrays:
			names.lower = records.lower
		and	names.upper = records.upper

end
