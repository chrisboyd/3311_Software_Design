note
	description: "Move operation with undo/redo"
	author: "JSO"
	date: "$Date$"
	revision: "$Revision$"

class
	MOVE_BISHOP

inherit

	MOVE
		redefine
			out
		end

	DEBUG_OUTPUT
		redefine
			out
		end

create
	make

feature {NONE} -- constructor

	make(a_new_position: SQUARE)
		do
			old_position := board.bishop_position
			position := a_new_position
		end

feature -- queries
		old_position: SQUARE
		position: SQUARE

	directions: ARRAY[TUPLE[x: INTEGER; y: INTEGER]]
		local
			i, l_size: INTEGER
		do
			--can move on diagonals
			--used for all possible moves relative to current position
			--being [x + i, y + i] such that x&y + i is on the board

			create Result.make_empty
			l_size := board.size

			from
				i := 1
			until
				i > l_size
			loop
				--add NE
				Result.force ([(-1 * i), i], Result.count + 1)
				--add SE
				Result.force ([i,i], Result.count + 1)
				--add SW
				Result.force ([i,(-1 * i)], Result.count + 1)
				--add NW
				Result.force ([(-1 * i),(-1 * i)], Result.count + 1)
				i := i + 1
			end

		end



feature -- commands

	execute
		do
			board.move_bishop(position)
		end

	undo
		do
			board.move_bishop (old_position)
		end

	redo
		do
--			board.history.forth
			execute
		end

feature

	out: STRING
		do
			Result := ""
		end

	debug_output: STRING
		do
			Result := out
		end

end
