note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_LAND
inherit
	ETF_LAND_INTERFACE
create
	make
feature -- command
	land
    	do
			if not (model.play_mode or model.test_mode) then
				model.set_error ("Negative on that request:no mission in progress.")
			elseif model.board.explorer.landed then
				model.set_error ("Negative on that request:already landed on a planet at Sector:" +
								model.board.explorer.location.out)
			else
				model.land_explorer
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
