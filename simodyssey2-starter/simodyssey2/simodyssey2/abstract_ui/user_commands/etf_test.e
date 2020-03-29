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
	test(a_threshold: INTEGER_32 ; j_threshold: INTEGER_32 ; m_threshold: INTEGER_32 ; b_threshold: INTEGER_32 ; p_threshold: INTEGER_32)
		require else
			test_precond(a_threshold, j_threshold, m_threshold, b_threshold, p_threshold)
    	do
			if (model.play_mode or model.test_mode) then
				model.set_error ("To start a new mission, please abort the current one first.")
			elseif not (0 < a_threshold and a_threshold <= j_threshold and j_threshold <= m_threshold and
						m_threshold <= b_threshold and b_threshold <= p_threshold and p_threshold <= 101) then
				model.set_error ("Thresholds should be non-decreasing order.")
			else
				model.set_test (True)
				model.initialize_game (a_threshold, j_threshold, m_threshold, b_threshold, p_threshold)
			end


			etf_cmd_container.on_change.notify ([Current])
    	end

end
