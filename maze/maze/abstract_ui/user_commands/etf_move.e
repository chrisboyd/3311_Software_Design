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
	move(a_direction: INTEGER_32)
		require else 
			move_precond(a_direction)
    	do
			-- perform some update on the model state
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
