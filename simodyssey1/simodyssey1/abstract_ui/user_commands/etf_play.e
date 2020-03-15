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
			if not model.is_playing then
				model.play
			else
				model.set_error ("  To start a new mission, please abort the current one first.")
			end

			etf_cmd_container.on_change.notify ([Current])
    	end

end
