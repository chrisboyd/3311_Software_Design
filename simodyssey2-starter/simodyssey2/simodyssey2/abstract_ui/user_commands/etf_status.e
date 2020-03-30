note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_STATUS
inherit
	ETF_STATUS_INTERFACE
create
	make
feature -- command
	status
    	do
    		if not model.play_mode or model.test_mode then
				model.set_error ("Negative on that request:no mission in progress.")
			else
				model.status
			end


			etf_cmd_container.on_change.notify ([Current])
    	end

end
