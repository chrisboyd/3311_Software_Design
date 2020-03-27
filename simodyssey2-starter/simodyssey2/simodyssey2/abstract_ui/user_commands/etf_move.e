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
    		if not (model.play_mode or model.test_mode) then
    			model.set_error ("Negative on that request:no mission in progress.")
    		elseif model.board.explorer.landed then
    			model.set_error ("Negative on that request:you are currently landed at Sector:" +
    							model.board.explorer.location.out)
    		else
    			
    		end

			etf_cmd_container.on_change.notify ([Current])
    	end

end
