note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_WORMHOLE

inherit

	ETF_WORMHOLE_INTERFACE

create
	make

feature -- command

	wormhole
			--send the explorer through a wormhole, if a game is in progress,
			--the explorer is not landed and there is a wormhole in the explorer's
			--sector
		do
				-- perform some update on the model state
			if not (model.play_mode or model.test_mode) then
				model.set_error ("Negative on that request:no mission in progress.")
			elseif model.board.explorer.landed then
				model.set_error ("Negative on that request:you are currently landed at Sector:" + model.board.explorer.location.out)
			elseif not model.board.explorer.location.has_wormhole then
				model.set_error ("Explorer couldn't find wormhole at Sector:" + model.board.explorer.location.out)
			else
				model.wormhole_explorer
			end
			etf_cmd_container.on_change.notify ([Current])
		end

end
