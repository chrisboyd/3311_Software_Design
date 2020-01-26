note
	description: "A position on a snooker table 356.9 cm by 177.8cm."
	author: "JSO"

class
	BALL_POINT

inherit

	CONSTANTS
		redefine
			out,
			is_equal
		end

	DEBUG_OUTPUT
		redefine
			out,
			is_equal
		end

create
	make,
	make_from_tuple2

convert -- safe type conversion

	make_from_tuple2 ({TUPLE2})

feature -- attributes

	x: DECIMAL
			-- x-coordinate of the ball

	y: DECIMAL
			-- y-coordinate of the ball

feature

	make (a_x, a_y: DECIMAL)
			-- create snooker ball at position [a_x, a_y]
		require
			x_precondition: zero <= a_x and a_x <= width
			y_precondition: zero <= a_y and a_y <= length
		do
			x := a_x
			y := a_y
		ensure
			x = a_x and y = a_y
		end

	make_from_tuple2 (t: TUPLE2)
			-- create a snooker ball at position `t`
		require
			safe (t.x, t.y)

		do
			x := t.x
			y := t.y
		ensure
			x = t.x and y = t.y
		end




	safe (a_x, a_y: DECIMAL): BOOLEAN
			-- is position [a_x, a_y] within the dimensions
			-- of the snooker table?
		do
			Result := (zero <= a_x
				and a_x <= width
				and zero <= a_y
				and a_y <= length)
		ensure
			class  -- static
			Result = (zero <= a_x
				and a_x <= width
				and zero <= a_y
				and a_y <= length)
		end



	t2ball (t: TUPLE2): like Current
			-- convert tuple `t` to a ball position
		require
				safe (t.x, t.y)
		do
			Result := create {BALL_POINT}.make_from_tuple2 (t)
		ensure
				class
				Result ~ create {BALL_POINT}.make_from_tuple2 (t)
		end

feature -- comparison

	is_equal (other: like Current): BOOLEAN
			-- Is other attached to an object considered
			-- equal to current object?
		do
			Result := (x ~ other.x and y ~ other.y)
		ensure then
				Result = (x ~ other.x and y ~ other.y)
		end

	distance (other: like Current): TUPLE2
			-- distance as a tuple from  current ball
			-- to position of other ball
		do
			Result := create {TUPLE2}.make_from_tuple ([other.x - x, other.y - y])
		ensure
			Result ~
			   create {TUPLE2}.make_from_tuple ([other.x - x, other.y - y])
		end

feature -- commands

	cue_delta (d_x, d_y: DECIMAL)
			-- move ball from current position by a delta [d_x, d_y]
		require
			x_cue_precondition: zero <= x + d_x and x + d_x <= width
			y_cue_precondition: zero <= y + d_y and y + d_y <= length
		do
			x := x + d_x
			y := y + d_y
		ensure
				x ~ (old x + d_x)
				y ~ (old y + d_y)
		end

feature -- out

	out: STRING_8
			-- New string containing terse printable representation
			-- of current object
		do
			Result := "(" + x.precise_out + "," + y.precise_out + ")"
		end

	debug_output: STRING_8
		-- String that should be displayed in debugger to represent Current.
		do
			Result := out
		end

invariant
	y_constraint:
		zero <= y and y <= length
	x_constraint:
		zero <= x and x <= width

end -- class BALL_POINT
