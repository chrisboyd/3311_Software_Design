note
	description: "[
		An Edge has a source and destination vertex:
			source: VERTEX [G]
			destination: VERTEX [G]
		An edge can be created from two vertices 
		or from a tuple (see convert).
		]"
	author: "JSO and JW"
	date: "$Date$"
	revision: "$Revision$"

class
	EDGE [G -> COMPARABLE]
inherit
	ANY
		redefine is_equal, out end

	DEBUG_OUTPUT -- for debugger view of an edge
		redefine is_equal, out end

create
	make, make_from_tuple

convert -- allows to create an edge from a tuple
	make_from_tuple ({TUPLE [VERTEX [G], VERTEX [G]]})

feature {NONE}  -- creation

	make (v1, v2: like source)
			-- Create an edge from vertices `v1` and `v2`
		do
			source := v1
			destination := v2
		end

	make_from_tuple (a_tuple: like as_tuple)
			-- Create an edge from a tuple of vertices
		do
			source := a_tuple.source
			destination := a_tuple.destination
		end

feature -- basic queries

	source: VERTEX [G]
		-- soure of edge

	destination: VERTEX [G]
		-- destination of edge

feature -- derived queries

	reverse_edge: like Current
			-- Return a new edge with reversed source and destination
		do
			Result := [destination, source]
		ensure
			destination ~ Result.source
			source ~ Result.destination
		end

	as_tuple: TUPLE [source: VERTEX [G]; destination: VERTEX [G]]
			-- Return the current edge as a tuple of vertices
		do
			Result := [source, destination]
		end

	is_self_loop: BOOLEAN
			-- Is the current edge a self loop?
		do
			Result := source ~ destination
		end

	is_equal(other: like Current): BOOLEAN
			-- Is the current edge equal to `other`?
		do
			Result :=
				source ~ other.source
				and
				destination ~ other.destination
		end

feature -- out

	out: STRING
			-- Return string representation of current edge
		do
			Result := source.out + "," + destination.item.out
		end

	debug_output: STRING
			-- Return string representation of current edge in debugger
		do
			Result := destination.item.out
		end

end
