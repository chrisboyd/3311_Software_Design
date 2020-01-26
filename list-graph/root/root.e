note
	description: "[
		ROOT class for Lab1: List Graph
		See tests in TEST_VERTEX_INSTRUCTOR.
	]"
	author: "JSO and JW and CD"

class ROOT inherit

	ES_SUITE -- testing via ESpec

create
	make

feature {NONE} -- Initialization

	make
			-- Run app
		do
			add_test (create {STUDENT_TEST}.make)
			add_test (create {TEST_VERTEX_INSTRUCTOR}.make)
			add_test (create {TEST_LIST_GRAPH_INSTRUCTOR}.make)
				-- Uncomment once you pass all tests in TEST_VERTEX_INSTRUCTOR.
			show_browser
			run_espec
		end

end
