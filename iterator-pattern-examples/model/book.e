note
	description: "Summary description for {BOOK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BOOK[G]

inherit
	ITERABLE[TUPLE[STRING, G]] -- when external clients use an across loop over a book,
													-- they get one tuple at a time.

create
	make

feature -- Commands
	make
		do
			create names.make_empty
			create records.make_empty
		end

feature -- Exercise
	add_record (n: STRING; r: G)
		do
			-- To DO
			names.force (n, names.count + 1)
			records.force (r, names.count + 1)
		end

feature -- Iterator
	new_cursor: ITERATION_CURSOR[TUPLE[STRING, G]]
		local
			cursor:  MY_BOOK_CURSOR[G]
		do
--			Result := names.new_cursor -- 1 ITERATION_CURSOR[STRING]
--			Result := records.new_cursor --2 ITERATION_CURSOR[G]
--			Result := [names.new_cursor , records.new_cursor] -- [ITERATION_CURSOR[STRING], ITERATION_CURSOR[G]]
			create {MY_BOOK_CURSOR[G]} Result.make (names, records)
--			create cursor.make (names, records)
--			Result := cursor
		end

feature {NONE} -- Attributes
	names: ARRAY[STRING]
	records: ARRAY[G]


end
