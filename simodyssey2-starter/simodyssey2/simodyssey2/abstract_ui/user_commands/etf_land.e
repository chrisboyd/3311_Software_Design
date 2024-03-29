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
			--if game in progress process land command
		do
			if not (model.play_mode or model.test_mode) then
				model.set_error ("Negative on that request:no mission in progress.")
			elseif model.game_board.explorer.landed then
				model.set_error ("Negative on that request:already landed on a planet at Sector:" + model.game_board.explorer.location.out)
			else
				model.land_explorer
			end
			etf_cmd_container.on_change.notify ([Current])
		end

end
