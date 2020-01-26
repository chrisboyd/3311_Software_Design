note
	description: "Summary description for {COURSE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	COURSE
inherit
	COMPARABLE
		redefine
			is_equal,
			out
		end

	DEBUG_OUTPUT
		redefine
			is_equal,
			out
		end

create
	make

feature {NONE} -- Initialization
	make (code: INTEGER; name: STRING; sem: STRING)
		require
			four_digit_code: code.out.count = 4
			correct_semester: sem ~ "F" or sem ~ "W" or sem ~ "S"
		do
			course_code := code
			course_name := name
			semester := sem
		end

feature -- Queries
	course_code: INTEGER

	course_name: STRING

	semester: STRING

	is_less alias "<" (other: COURSE): BOOLEAN
		do
			Result := Current.course_code < other.course_code
		end

	is_equal (other: COURSE): BOOLEAN
		do
			Result := Current.course_code ~ other.course_code
		end

	out: STRING
		do
			create Result.make_empty
			Result.append (course_code.out)
		end

	debug_output: STRING
		do
			Result := out
		end

feature -- Commands

	set_code (new_code: INTEGER)
		require
			four_digit_code: new_code.out.count = 4
		do
			course_code := new_code
		end

	set_name (new_name: STRING)
		do
			course_name := new_name
		end

	set_semester (new_sem: STRING)
		require
			correct_sem: new_sem ~ "F" or new_sem ~ "W" or new_sem ~ "S"
		do
			semester := new_sem
		end


invariant
	four_digit_code: course_code.out.count ~ 4
	good_semester: semester ~ "F" or semester ~ "W" or semester ~ "S"

end
