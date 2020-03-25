note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MOVE_KNIGHT
inherit
	ETF_MOVE_KNIGHT_INTERFACE
create
	make
feature -- command
	move_knight(square: TUPLE[x: INTEGER_32; y: INTEGER_32])
		require else
			move_knight_precond(square)
		local
			new_square: SQUARE
			old_square: SQUARE
			l_x,l_y: INTEGER
			op: MOVE_KNIGHT
			moves: ARRAY[SQUARE]
    	do

			-- create move op
			old_square := model.board.knight_position
			l_x := square.x.as_integer_32
			l_y := square.y.as_integer_32
			create new_square.make (l_x, l_y)
			create op.make (new_square)
			moves := op.moves (old_square.x, old_square.y)
			if moves.has (new_square) then
				model.board.history.extend_history (op)
				model.set_message ("ok")
				op.execute
			else
				model.set_message ("invalid move")
			end

			-- push
			etf_cmd_container.on_change.notify ([Current])
    	end
end
