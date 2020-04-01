note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MOVE_KING
inherit 
	ETF_MOVE_KING_INTERFACE
create
	make
feature -- command 
	move_king(square: TUPLE[x: INTEGER_32; y: INTEGER_32])
		require else 
			move_king_precond(square)
    	do
			-- perform some update on the model state
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
