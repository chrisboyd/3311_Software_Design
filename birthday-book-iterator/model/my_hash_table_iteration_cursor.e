note
	description: "Summary description for {MY_HASH_TABLE_ITERATION_CURSOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MY_HASH_TABLE_ITERATION_CURSOR[G, H -> HASHABLE]

inherit
	ITERATION_CURSOR[TUPLE[G, H]]

create
	make

feature {NONE} -- Implementation
	ht: HASH_TABLE[G, H]
	ic: HASH_TABLE_ITERATION_CURSOR[G, H]

feature -- Commands
	make (imp: HASH_TABLE[G, H])
		do
			ht := imp
			ic := imp.new_cursor
		end

feature -- Cursor
	item: TUPLE[G, H]
		do
			Result := [ic.item, ic.key]
		end

	after: BOOLEAN
		do
			Result := ic.after
		end

	forth
		do
			ic.forth
		end
end
