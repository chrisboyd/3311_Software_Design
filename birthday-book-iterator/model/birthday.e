note
	description: "A BIRTHDAY is a [day, month]"
	author: "JSO"
	date: "$Date$"
	revision: "$Revision$"

class BIRTHDAY inherit
	ANY
		redefine
			out
		end
create
	make, make_from_tuple
convert
	make_from_tuple ({TUPLE [INTEGER, INTEGER]})

feature {NONE} -- Initialization

	make (a_month: INTEGER; a_day: INTEGER)
		require valid(a_day, a_month)
		do
			month := a_month
			day := a_day
		end

	make_from_tuple (t: TUPLE [day: INTEGER; month: INTEGER])
		require
			t.count = 2
			attached {INTEGER} t.day
			attached {INTEGER} t.month
			valid(t.day,t.month)
		do
			make (t.month, t.day)
		end

feature
	day: INTEGER
	month: INTEGER

	valid(a_day, a_month: INTEGER): BOOLEAN
		do
			Result :=
			    (1 <= a_day and a_day <= 31)
				and (1 <= a_month and a_month <= 12)
		end

	out: STRING
		do
			result := "(" + day.out + "," + month.out + ")"
		end

invariant
	1 <= month and month <= 12
	1 <= day and day <= 31

end
