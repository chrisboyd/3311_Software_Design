note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_LIFTOFF

inherit

	ETF_LIFTOFF_INTERFACE

create
	make

feature -- command

	liftoff
			--if a game is in progress, process liftoff command
		do
			if not (model.play_mode or model.test_mode) then
				model.set_error ("Negative on that request:no mission in progress.")
			elseif not model.game_board.explorer.landed then
				model.set_error ("Negative on that request:you are not on a planet at Sector:" + model.game_board.explorer.location.out)
			else
				model.liftoff_explorer
			end
			etf_cmd_container.on_change.notify ([Current])
		end

end
