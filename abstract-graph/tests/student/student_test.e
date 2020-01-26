note
	description: "Summary description for {STUDENT_TEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STUDENT_TEST

inherit
	ES_TEST

create
	make
feature {NONE} -- Initialization

	make
		do
			add_boolean_case(agent t1)
			add_boolean_case(agent t2)
			add_boolean_case(agent t3)
			add_boolean_case(agent t4)
			add_boolean_case(agent t5)
		end

feature -- Tests

	t1: BOOLEAN
		do
			comment("t1: Test description goes here")
			Result := False
		end

	t2: BOOLEAN
		do
			comment("t2: Test description goes here")
			Result := False
		end

	t3: BOOLEAN
		do
			comment("t3: Test description goes here")
			Result := False
		end

	t4: BOOLEAN
		do
			comment("t4: Test description goes here")
			Result := False
		end

	t5: BOOLEAN
		do
			comment("t5: Test description goes here")
			Result := False
		end
end
