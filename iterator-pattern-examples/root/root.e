note
	description: "[
		Tests of the Iterator Design Patterns
	]"
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	ROOT

inherit

	ARGUMENTS_32

	ES_SUITE -- testing via ESpec

create
	make

feature {NONE} -- Initialization

	make
			-- Run app
		do 
			add_test (create {TEST_ITERATORS}.make) --suite of tests
			show_browser
			run_espec
		end

end
