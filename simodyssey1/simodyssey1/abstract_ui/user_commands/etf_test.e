note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_TEST
inherit
	ETF_TEST_INTERFACE
create
	make
feature -- command
	test(p_threshold: INTEGER_32)
		require else
			test_precond(p_threshold)
    	do
			if not model.is_playing then
				model.test(p_threshold)
			else
				model.set_error ("  To start a new mission, please abort the current one first.")
			end

			etf_cmd_container.on_change.notify ([Current])
    	end

end
