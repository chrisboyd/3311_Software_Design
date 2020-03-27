note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_PLAY
inherit
	ETF_PLAY_INTERFACE
create
	make
feature -- command
	play
    	do
			-- perform some update on the model state
			--model.default_update
			if model.play_mode or model.test_mode then
				model.set_error ("To start a new mission, please abort the current one first.")
			else
				model.set_play (True)
				model.initialize_game (3, 5, 7, 15, 30)
			end

			etf_cmd_container.on_change.notify ([Current])
    	end

end
