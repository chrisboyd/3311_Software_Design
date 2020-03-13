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
	move(dir: INTEGER_32)
		require else
			move_precond(dir)
    	do
			-- perform some update on the model state
			inspect dir
			when N then
				model.move (-1, 0)
			when NE then
				model.move (-1, 1)
			when E then
				model.move (0, 1)
			when SE then
				model.move (1, 1)
			when S then
				model.move (1, 0)
			when SW then
				model.move (1, -1)
			when W then
				model.move (0, -1)
			when NW then
				model.move (-1, -1)
			else
				model.move (0, 0)
			end -- inspect

			etf_cmd_container.on_change.notify ([Current])
    	end

end
