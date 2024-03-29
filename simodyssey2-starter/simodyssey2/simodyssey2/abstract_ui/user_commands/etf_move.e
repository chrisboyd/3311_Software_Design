note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MOVE

inherit

	ETF_MOVE_INTERFACE

create
	make

feature -- command

	move (direction: INTEGER_32)
			--move explorer in direction specified, if the destination is not full
		require else
			move_precond (direction)
		local
			start: PAIR [INTEGER, INTEGER]
			dest: PAIR [INTEGER, INTEGER]
			inc: PAIR [INTEGER, INTEGER]
		do
			if not (model.play_mode or model.test_mode) then
				model.set_error ("Negative on that request:no mission in progress.")
			elseif model.game_board.explorer.landed then
				model.set_error ("Negative on that request:you are currently landed at Sector:" + model.game_board.explorer.location.out)
			else
				create start.make (model.game_board.explorer.location.row, model.game_board.explorer.location.column)
				inc := model.map_direction (direction)
				dest := model.get_dest_coord (start, inc)
				if model.game_board.get_sector (dest.first, dest.second).is_full then
					model.set_error ("Cannot transfer to new location as it is full.")
				else
					model.move_explorer (dest.first, dest.second)
				end
			end
			etf_cmd_container.on_change.notify ([Current])
		end

end
