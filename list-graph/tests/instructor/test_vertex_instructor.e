note
	description: "Summary description for {TEST_VERTEX_INSTRUCTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	ca_ignore: "CA033", "CA085"

class
	TEST_VERTEX_INSTRUCTOR

inherit

	ES_TEST

create
	make

feature {NONE} -- Initialization

	make
			-- add tests
		do
			add_boolean_case (agent t1)
			add_boolean_case (agent t2)
			add_boolean_case (agent t3)
			add_boolean_case (agent t3b)
			add_boolean_case (agent t3c)
			add_boolean_case (agent t4)
			add_boolean_case (agent t4c)
			add_boolean_case (agent t5)
			add_boolean_case (agent t6)
			add_boolean_case (agent t6c)
			add_boolean_case (agent t7)
			add_boolean_case (agent t9)
			add_boolean_case (agent t9b)
			add_boolean_case (agent t9c)
			add_boolean_case (agent t10)
			add_boolean_case (agent t11)
			add_boolean_case (agent t12)
			add_boolean_case (agent t12b)
			add_boolean_case (agent t12c)
			add_boolean_case (agent t13)
			add_boolean_case (agent t14)
			add_boolean_case (agent t15)
			add_boolean_case (agent t16b)
			add_boolean_case (agent t16c)
			add_boolean_case (agent t17)
			add_boolean_case (agent t17b)
			add_boolean_case (agent t17c)
		end

feature -- Creation Procedure Tests

	t1: BOOLEAN -- Vertex Creation Test - Integer
		local
			v1: VERTEX [INTEGER]
		do
			comment ("t1: Creation Procedure - make - Integer Case")
			create v1.make (4)
			Result := v1.item ~ 4
			check
				Result
			end
			create v1.make (-1)
			Result := v1.item ~ -1
			check
				Result
			end
			create v1.make (0)
			Result := v1.item ~ 0
			check
				Result
			end
		end

	t2: BOOLEAN -- Vertex Creation Test - String
		local
			v1: VERTEX [STRING]
		do
			comment ("t2: Creation Procedure - make - String Case")
			create v1.make ("4")
			Result := v1.item ~ "4"
			check
				Result
			end
			create v1.make ("Z")
			Result := v1.item ~ "Z" and v1.item /~ "z"
			check
				Result
			end
			create v1.make ("foo")
			Result := v1.item ~ "foo"
			check
				Result
			end
		end

	t3: BOOLEAN -- Command Testing - add_edge, outgoing, incoming - Integer
		local
			v1, v2: VERTEX [INTEGER]
			e1: EDGE [INTEGER]
		do
			comment ("t3: Edges - add_edge, outgoing, incoming - Integer Case")
			create v1.make (4)
			create v2.make (-1)
			create e1.make (v1, v2)
			v1.add_edge (e1)
			Result := v1.outgoing.count ~ 1 and v1.incoming.count ~ 0
			check
				Result
			end
			Result := v2.outgoing.count ~ 0 and v1.incoming.count ~ 0
			check
				Result
			end
			v2.add_edge (e1)
			Result := v2.outgoing.count ~ 0 and v2.incoming.count ~ 1
			check
				Result
			end
		end

	t3b: BOOLEAN -- Command Testing - add_edge, outgoing, incoming - String
		local
			v1, v2: VERTEX [STRING]
			e1: EDGE [STRING]
		do
			comment ("t3b: Edges - add_edge, outgoing, incoming - String Case")
			create v1.make ("d")
			create v2.make ("Z")
			create e1.make (v1, v2)
			v1.add_edge (e1)
			Result := v1.outgoing.count ~ 1 and v1.incoming.count ~ 0
			check
				Result
			end
			Result := v2.outgoing.count ~ 0 and v1.incoming.count ~ 0
			check
				Result
			end
			v2.add_edge (e1)
			Result := v2.outgoing.count ~ 0 and v2.incoming.count ~ 1
			check
				Result
			end
		end

	t3c: BOOLEAN -- Command Testing - add_edge, outgoing, incoming - Course
		local
			v1, v2: VERTEX [COURSE]
			e1: EDGE [COURSE]
		do
			comment ("t3c: Edges - add_edge, outgoing, incoming - Course Case")
			create v1.make (create {COURSE}.make (3311, "Software Design", "W"))
			create v2.make (create {COURSE}.make (3101, "Algorithms", "W"))
			create e1.make (v1, v2)
			v1.add_edge (e1)
			Result := v1.outgoing.count ~ 1 and v1.incoming.count ~ 0
			check
				Result
			end
			Result := v2.outgoing.count ~ 0 and v1.incoming.count ~ 0
			check
				Result
			end
			v2.add_edge (e1)
			Result := v2.outgoing.count ~ 0 and v2.incoming.count ~ 1
			check
				Result
			end
		end

	t4: BOOLEAN -- Command Testing - add_edge, outgoing, incoming - Integer
		local
			v1, v2: VERTEX [INTEGER]
			e1: EDGE [INTEGER]
		do
			comment ("t4: Edges - add_edge, outgoing, incoming - Integer Case")
			create v1.make (4)
			create v2.make (-1)
			create e1.make (v1, v2)
			v1.add_edge (e1)
			Result := v1.outgoing.count ~ 1 and v1.incoming.count ~ 0 and v1.outgoing.has (e1)
			check
				Result
			end
			Result := v2.outgoing.count ~ 0 and v1.incoming.count ~ 0
			check
				Result
			end
			v2.add_edge (e1)
			Result := v2.outgoing.count ~ 0 and v2.incoming.count ~ 1 and v2.incoming.has (e1)
			check
				Result
			end
			create v2.make (3)
			create e1.make (v2, v1)
			v1.add_edge (e1)
			Result := v1.outgoing.count ~ 1 and v1.incoming.count ~ 1 and v1.incoming.has (e1)
			check
				Result
			end

				-- Try making new vertices (same items) and make sure incoming/outgoing is empty
			create v1.make (4)
			create v2.make (3)
			Result := v1.incoming.is_empty and v1.outgoing.is_empty and v2.incoming.is_empty and v2.outgoing.is_empty
		end

	t4c: BOOLEAN -- Command Testing - add_edge, outgoing, incoming - Course
		local
			v1, v2: VERTEX [COURSE]
			e1: EDGE [COURSE]
		do
			comment ("t4c: Edges - add_edge, outgoing, incoming - Course Case")
			create v1.make (create {COURSE}.make (2211, "Data Structures", "F"))
			create v2.make (create {COURSE}.make (2200, "Computer Organization", "F"))
			create e1.make (v1, v2)
			v1.add_edge (e1)
			Result := v1.outgoing.count ~ 1 and v1.incoming.count ~ 0 and v1.outgoing.has (e1)
			check
				Result
			end
			Result := v2.outgoing.count ~ 0 and v1.incoming.count ~ 0
			check
				Result
			end
			v2.add_edge (e1)
			Result := v2.outgoing.count ~ 0 and v2.incoming.count ~ 1 and v2.incoming.has (e1)
			check
				Result
			end
			create v2.make (create {COURSE}.make (3216, "Embedded Systems", "W"))
			create e1.make (v2, v1)
			v1.add_edge (e1)
			Result := v1.outgoing.count ~ 1 and v1.incoming.count ~ 1 and v1.incoming.has (e1)
			check
				Result
			end

				-- Try making new vertices (same items) and make sure incoming/outgoing is empty
			create v1.make (create {COURSE}.make (3216, "Embedded Systems", "W"))
			create v2.make (create {COURSE}.make (2211, "Data Structures", "F"))
			Result := v1.incoming.is_empty and v1.outgoing.is_empty and v2.incoming.is_empty and v2.outgoing.is_empty
		end

	t5: BOOLEAN -- Command Testing - add_edge, outgoing, incoming - Integer
		local
			v1, v2: VERTEX [INTEGER]
			e1: EDGE [INTEGER]
		do
			comment ("t5: Edges - add_edge, outgoing, incoming - Integer Self-Loop Case")
			create v1.make (4)
			create v2.make (-1)
			create e1.make (v1, v2)
			v1.add_edge (e1)
			Result := v1.outgoing.count ~ 1 and v1.incoming.count ~ 0 and v1.outgoing.has (e1)
			check
				Result
			end
			Result := v2.outgoing.count ~ 0 and v1.incoming.count ~ 0
			check
				Result
			end
			v2.add_edge (e1)
			Result := v2.outgoing.count ~ 0 and v2.incoming.count ~ 1 and v2.incoming.has (e1)
			check
				Result
			end
			create v2.make (3)
			create e1.make (v2, v1)
			v1.add_edge (e1)
			Result := v1.outgoing.count ~ 1 and v1.incoming.count ~ 1 and v1.incoming.has (e1)
			check
				Result
			end

				-- Try adding self loop
			create e1.make (v1, v1)
			v1.add_edge (e1)
			Result := v1.incoming.has (e1) and v1.outgoing.has (e1) and v1.edge_count ~ 4
			check
				Result
			end
		end

	t6: BOOLEAN -- Queries - incoming_edge_count, outgoing_edge_count - Integer Case
		local
			v1, v2: VERTEX [INTEGER]
			e1: EDGE [INTEGER]
		do
			comment ("t6: Queries - incoming_edge_count, outgoing_edge_count - Integer Case")
			create v1.make (4)
			create v2.make (-1)
			create e1.make (v1, v2)
			v1.add_edge (e1)
			Result := v1.outgoing_edge_count ~ 1 and v1.incoming_edge_count ~ 0 and v1.outgoing.has (e1)
			check
				Result
			end
			Result := v2.outgoing_edge_count ~ 0 and v1.incoming_edge_count ~ 0
			check
				Result
			end
			v2.add_edge (e1)
			Result := v2.outgoing_edge_count ~ 0 and v2.incoming_edge_count ~ 1 and v2.incoming.has (e1)
			check
				Result
			end
			create v2.make (3)
			create e1.make (v2, v1)
			v1.add_edge (e1)
			Result := v1.outgoing_edge_count ~ 1 and v1.incoming_edge_count ~ 1 and v1.incoming.has (e1)
			check
				Result
			end
		end

	t6c: BOOLEAN -- Queries - incoming_edge_count, outgoing_edge_count - Course Case
		local
			v1, v2: VERTEX [COURSE]
			e1: EDGE [COURSE]
		do
			comment ("t6c: Queries - incoming_edge_count, outgoing_edge_count - Course Case")
			create v1.make (create {COURSE}.make (2211, "Data Structures", "F"))
			create v2.make (create {COURSE}.make (3311, "Software Design", "F"))
			create e1.make (v1, v2)
			v1.add_edge (e1)
			Result := v1.outgoing_edge_count ~ 1 and v1.incoming_edge_count ~ 0 and v1.outgoing.has (e1)
			check
				Result
			end
			Result := v2.outgoing_edge_count ~ 0 and v1.incoming_edge_count ~ 0
			check
				Result
			end
			v2.add_edge (e1)
			Result := v2.outgoing_edge_count ~ 0 and v2.incoming_edge_count ~ 1 and v2.incoming.has (e1)
			check
				Result
			end
			create v2.make (create {COURSE}.make (3101, "Algorithms", "F"))
			create e1.make (v2, v1)
			v1.add_edge (e1)
			Result := v1.outgoing_edge_count ~ 1 and v1.incoming_edge_count ~ 1 and v1.incoming.has (e1)
			check
				Result
			end
		end

	t7: BOOLEAN -- Command Testing - incoming_edge_count, outgoing_edge_count - Integer Self-Loop
		local
			v1, v2: VERTEX [INTEGER]
			e1: EDGE [INTEGER]
		do
			comment ("t7: Queries - incoming_edge_count, outgoing_edge_count - Integer Self-Loop Case")
			create v1.make (4)
			create v2.make (-1)
			create e1.make (v1, v2)
			v1.add_edge (e1)
			Result := v1.outgoing_edge_count ~ 1 and v1.incoming_edge_count ~ 0 and v1.outgoing.has (e1)
			check
				Result
			end
			Result := v2.outgoing_edge_count ~ 0 and v1.incoming_edge_count ~ 0
			check
				Result
			end
			v2.add_edge (e1)
			Result := v2.outgoing_edge_count ~ 0 and v2.incoming_edge_count ~ 1 and v2.incoming.has (e1)
			check
				Result
			end
			create v2.make (3)
			create e1.make (v2, v1)
			v1.add_edge (e1)
			Result := v1.outgoing_edge_count ~ 1 and v1.incoming_edge_count ~ 1 and v1.incoming.has (e1)
			check
				Result
			end

				-- Try adding self loop
			create e1.make (v1, v1)
			v1.add_edge (e1)
			Result := v1.incoming.has (e1) and v1.outgoing.has (e1) and (v1.incoming_edge_count + v1.outgoing_edge_count) ~ 4
			check
				Result
			end
		end

	t9: BOOLEAN -- Command Testing - remove_edge - Integer
		local
			v1, v2: VERTEX [INTEGER]
			e1, e2: EDGE [INTEGER]
		do
			comment ("t9: Edges - remove_edge, add_edge, outgoing, incoming - Integer Case")
			create v1.make (4)
			create v2.make (-1)
			create e1.make (v1, v2)
			v1.add_edge (e1)
			Result := v1.outgoing.count ~ 1 and v1.incoming.count ~ 0 and v1.outgoing.has (e1)
			check
				Result
			end
			Result := v2.outgoing.count ~ 0 and v1.incoming.count ~ 0
			check
				Result
			end
			v2.add_edge (e1)
			Result := v2.outgoing.count ~ 0 and v2.incoming.count ~ 1 and v2.incoming.has (e1)
			check
				Result
			end
			create v2.make (3)
			create e2.make (v2, v1)
			v1.add_edge (e2)
			Result := v1.outgoing.count ~ 1 and v1.incoming.count ~ 1 and v1.incoming.has (e2)
			check
				Result
			end
			v1.remove_edge (v1.outgoing [1])
			Result := v1.has_incoming_edge (e2) and not v1.has_outgoing_edge (e1)
			check
				Result
			end
			v1.remove_edge (v1.incoming [1])
			Result := v1.incoming.is_empty and v1.outgoing.is_empty
			check
				Result
			end
		end

	t9b: BOOLEAN -- Command Testing - remove_edge - String
		local
			v1, v2: VERTEX [STRING]
			e1, e2: EDGE [STRING]
		do
			comment ("t9b: Edges - remove_edge, add_edge, outgoing, incoming - String Case")
			create v1.make ("d")
			create v2.make ("Z")
			create e1.make (v1, v2)
			v1.add_edge (e1)
			Result := v1.outgoing.count ~ 1 and v1.incoming.count ~ 0 and v1.outgoing.has (e1)
			check
				Result
			end
			Result := v2.outgoing.count ~ 0 and v1.incoming.count ~ 0
			check
				Result
			end
			v2.add_edge (e1)
			Result := v2.outgoing.count ~ 0 and v2.incoming.count ~ 1 and v2.incoming.has (e1)
			check
				Result
			end
			create v2.make ("c")
			create e2.make (v2, v1)
			v1.add_edge (e2)
			Result := v1.outgoing.count ~ 1 and v1.incoming.count ~ 1 and v1.incoming.has (e2)
			check
				Result
			end
			v1.remove_edge (v1.outgoing [1])
			Result := v1.has_incoming_edge (e2) and not v1.has_outgoing_edge (e1)
			check
				Result
			end
			v1.remove_edge (v1.incoming [1])
			Result := v1.incoming.is_empty and v1.outgoing.is_empty
			check
				Result
			end
		end

	t9c: BOOLEAN -- Command Testing - remove_edge - Course
		local
			v1, v2: VERTEX [COURSE]
			e1, e2: EDGE [COURSE]
		do
			comment ("t9c: Edges - remove_edge, add_edge, outgoing, incoming - Course Case")
			create v1.make (create {COURSE}.make (3311, "Software Design", "F"))
			create v2.make (create {COURSE}.make (3101, "Algorithms", "W"))
			create e1.make (v1, v2)
			v1.add_edge (e1)
			Result := v1.outgoing.count ~ 1 and v1.incoming.count ~ 0 and v1.outgoing.has (e1)
			check
				Result
			end
			Result := v2.outgoing.count ~ 0 and v1.incoming.count ~ 0
			check
				Result
			end
			v2.add_edge (e1)
			Result := v2.outgoing.count ~ 0 and v2.incoming.count ~ 1 and v2.incoming.has (e1)
			check
				Result
			end
			create v2.make (create {COURSE}.make (3215, "Embedded Systems", "W"))
			create e2.make (v2, v1)
			v1.add_edge (e2)
			Result := v1.outgoing.count ~ 1 and v1.incoming.count ~ 1 and v1.incoming.has (e2)
			check
				Result
			end
			v1.remove_edge (v1.outgoing [1])
			Result := v1.has_incoming_edge (e2) and not v1.has_outgoing_edge (e1)
			check
				Result
			end
			v1.remove_edge (v1.incoming [1])
			Result := v1.incoming.is_empty and v1.outgoing.is_empty
			check
				Result
			end
		end

	t10: BOOLEAN -- Command Testing -  remove_edge, outgoing, incoming - Integer
		local
			v1, v2: VERTEX [INTEGER]
			e1: EDGE [INTEGER]
		do
			comment ("t10: Edges - remove_edge - Integer Self-Loop Case")
			create v1.make (4)
			create v2.make (-1)
			create e1.make (v1, v2)
			v1.add_edge (e1)
			Result := v1.outgoing.count ~ 1 and v1.incoming.count ~ 0 and v1.outgoing.has (e1)
			check
				Result
			end
			Result := v2.outgoing.count ~ 0 and v1.incoming.count ~ 0
			check
				Result
			end
			v2.add_edge (e1)
			Result := v2.outgoing.count ~ 0 and v2.incoming.count ~ 1 and v2.incoming.has (e1)
			check
				Result
			end
			create v2.make (3)
			create e1.make (v2, v1)
			v1.add_edge (e1)
			Result := v1.outgoing.count ~ 1 and v1.incoming.count ~ 1 and v1.incoming.has (e1)
			check
				Result
			end

				-- Add self loop
			create e1.make (v1, v1)
			v1.add_edge (e1)
			Result := v1.incoming.has (e1) and v1.outgoing.has (e1) and v1.edge_count ~ 4
			check
				Result
			end

				-- Remove it via reference to object
			v1.remove_edge (e1)
			Result := not v1.incoming.has (e1) and not v1.outgoing.has (e1)
			check
				Result
			end

				-- Add self loop again
			create e1.make (v1, v1)
			v1.add_edge (e1)
			Result := v1.incoming.has (e1) and v1.outgoing.has (e1) and v1.edge_count ~ 4
			check
				Result
			end

				-- Remove it again
			v1.remove_edge (e1)
			Result := not v1.incoming.has (e1) and not v1.outgoing.has (e1)
			check
				Result
			end
		end

	t11: BOOLEAN -- has_outgoing_edge - Basic Integer
		local
			v1, v2: VERTEX [INTEGER]
			e: EDGE [INTEGER]
		do
			comment ("t11: Queries - has_outgoing_edge - Basic Integer Case")
			create v1.make (-55)
			create v2.make (1)
			create e.make (v1, v2)
			v1.add_edge (e)
			v2.add_edge (e)
			Result := v1.has_outgoing_edge (e)
			check
				Result
			end
			Result := not v2.has_outgoing_edge (e)
			check
				Result
			end
		end

	t12: BOOLEAN -- has_outgoing_edge - Integer Object Comparison Check
		local
			v1, v2: VERTEX [INTEGER]
			e, tmp_e: EDGE [INTEGER]
		do
			comment ("t12: Queries - has_outgoing_edge - Integer Object Comparison Check")
			create v1.make (-55)
			create v2.make (1)
			create e.make (v1, v2)
			v1.add_edge (e)
			v2.add_edge (e)
			Result := v1.has_outgoing_edge (e)
			check
				Result
			end
			Result := not v2.has_outgoing_edge (e)
			check
				Result
			end

				-- make a new edge from new vertices with the same item and check
			create tmp_e.make (v1.twin, v2.twin)
			Result := v1.has_outgoing_edge (tmp_e)
			check
				Result
			end
			Result := not v2.has_outgoing_edge (tmp_e)
			check
				Result
			end
		end

	t12b: BOOLEAN -- has_outgoing_edge - String Check Object Comparison
		local
			v1, v2: VERTEX [STRING]
			e, tmp_e: EDGE [STRING]
		do
			comment ("t12b: Queries - has_outgoing_edge - String Object Comparison Check")
			create v1.make ("Z")
			create v2.make ("a")
			create e.make (v1, v2)
			v1.add_edge (e)
			v2.add_edge (e)
			Result := v1.has_outgoing_edge (e)
			check
				Result
			end
			Result := not v2.has_outgoing_edge (e)
			check
				Result
			end

				-- make a new edge from new vertices with the same item and check
			create tmp_e.make (v1.twin, v2.twin)
			Result := v1.has_outgoing_edge (tmp_e)
			check
				Result
			end
			Result := not v2.has_outgoing_edge (tmp_e)
			check
				Result
			end
		end

	t12c: BOOLEAN -- has_outgoing_edge - Check Object Comparison Course
		local
			v1, v2: VERTEX [COURSE]
			e, tmp_e: EDGE [COURSE]
		do
			comment ("t12c: Queries - has_outgoing_edge - Object Comparison Check Course")
			create v1.make (create {COURSE}.make (3311, "Software Design", "F"))
			create v2.make (create {COURSE}.make (3101, "Algorithms", "F"))
			create e.make (v1, v2)
			v1.add_edge (e)
			v2.add_edge (e)
			Result := v1.has_outgoing_edge (e)
			check
				Result
			end
			Result := not v2.has_outgoing_edge (e)
			check
				Result
			end

				-- make a new edge from new vertices with the same item and check
			create tmp_e.make (v1.twin, v2.twin)
			Result := v1.has_outgoing_edge (tmp_e)
			check
				Result
			end
			Result := not v2.has_outgoing_edge (tmp_e)
			check
				Result
			end
		end

	t13: BOOLEAN -- has_outgoing_edge - Integer Self Loop
		local
			v1, v2: VERTEX [INTEGER]
			e1, e2: EDGE [INTEGER]
		do
			comment ("t13: Queries - has_outgoing_edge - Integer Self Loop")
			create v1.make (-55)
			create v2.make (1)
			create e1.make (v1, v2)
			v1.add_edge (e1)
			v2.add_edge (e1)
			Result := v1.has_outgoing_edge (e1)
			check
				Result
			end
			Result := not v2.has_outgoing_edge (e1)
			check
				Result
			end

				-- make self-loop
			create e2.make (v1, v1)
			v1.add_edge (e2)
			Result := v1.has_outgoing_edge (e2)
			check
				Result
			end
		end

	t14: BOOLEAN -- has_incoming_edge - Basic Integer
		local
			v1, v2: VERTEX [INTEGER]
			e: EDGE [INTEGER]
		do
			comment ("t14: Queries - has_incoming_edge - Basic Integer Case")
			create v1.make (-55)
			create v2.make (1)
			create e.make (v1, v2)
			v1.add_edge (e)
			v2.add_edge (e)
			Result := not v1.has_incoming_edge (e)
			check
				Result
			end
			Result := v2.has_incoming_edge (e)
			check
				Result
			end
		end

	t15: BOOLEAN -- has_incoming_edge - Check Object Comparison
		local
			v1, v2, v3, v4: VERTEX [INTEGER]
			e, tmp_e: EDGE [INTEGER]
		do
			comment ("t15: Queries - has_incoming_edge - Object Comparison Check")
			create v1.make (-55)
			create v2.make (1)
			create e.make (v1, v2)
			v1.add_edge (e)
			v2.add_edge (e)
			Result := not v1.has_incoming_edge (e)
			check
				Result
			end
			Result := v2.has_incoming_edge (e)
			check
				Result
			end

				-- make a new edge from new vertices with the same item and check
			v3 := v1.twin
			v4 := v2.twin
			create tmp_e.make (v3, v4)
			Result := not v1.has_incoming_edge (tmp_e)
			check
				Result
			end
			Result := v2.has_incoming_edge (tmp_e)
			check
				Result
			end
		end

	t16b: BOOLEAN -- has_incoming_edge - String Self Loop
		local
			v1, v2: VERTEX [STRING]
			e1, e2: EDGE [STRING]
		do
			comment ("t16b: Queries - has_incoming_edge - String Self Loop")
			create v1.make ("Z")
			create v2.make ("c")
			create e1.make (v1, v2)
			v1.add_edge (e1)
			v2.add_edge (e1)
			Result := not v1.has_incoming_edge (e1)
			check
				Result
			end
			Result := v2.has_incoming_edge (e1)
			check
				Result
			end

				-- make self-loop
			create e2.make (v1, v1)
			v1.add_edge (e2)
			Result := v1.has_incoming_edge (e2)
			check
				Result
			end
		end

	t16c: BOOLEAN -- has_incoming_edge - Course Self Loop
		local
			v1, v2: VERTEX [COURSE]
			e1, e2: EDGE [COURSE]
		do
			comment ("t16c: Queries - has_incoming_edge - Course Self Loop")
			create v1.make (create {COURSE}.make (3311, "Software Design", "F"))
			create v2.make (create {COURSE}.make (3101, "Algorithms", "W"))
			create e1.make (v1, v2)
			v1.add_edge (e1)
			v2.add_edge (e1)
			Result := not v1.has_incoming_edge (e1)
			check
				Result
			end
			Result := v2.has_incoming_edge (e1)
			check
				Result
			end

				-- make self-loop
			create e2.make (v1, v1)
			v1.add_edge (e2)
			Result := v1.has_incoming_edge (e2)
			check
				Result
			end
		end

	t17: BOOLEAN -- outgoing_sorted - Integer Basic
		local
			v1, v2, v3, v4: VERTEX [INTEGER]
			e: EDGE [INTEGER]
			sorted_edges: ARRAY [EDGE [INTEGER]]
			sorted_out: STRING
		do
			comment ("t17: Queries - outgoing_sorted - Integer Basic")
			create v1.make (1)
			create v2.make (2)
			create v3.make (3)
			create v4.make (4)
			create e.make (v1, v2)
			v1.add_edge (e)
			v2.add_edge (e)
			create e.make (v1, v4)
			v1.add_edge (e)
			v4.add_edge (e)
			create e.make (v1, v3)
			v1.add_edge (e)
			v3.add_edge (e)
			sorted_edges := v1.outgoing_sorted
			Result := sorted_edges.count ~ 3
			create sorted_out.make_empty
			across
				sorted_edges as curr_edge
			loop
				sorted_out.append (curr_edge.item.destination.out)
				sorted_out.append (" ")
			end
			assert_equal ("outgoing_sorted_correct", "1:2,3,4", v1.out)
		end

	t17b: BOOLEAN -- outgoing_sorted - String Basic
		local
			v1, v2, v3, v4: VERTEX [STRING]
			e: EDGE [STRING]
			sorted_edges: ARRAY [EDGE [STRING]]
			sorted_out: STRING
		do
			comment ("t17b: Queries - outgoing_sorted - String Basic")
			create v1.make ("a")
			create v2.make ("b")
			create v3.make ("d")
			create v4.make ("c")
			create e.make (v1, v2)
			v1.add_edge (e)
			v2.add_edge (e)
			create e.make (v1, v4)
			v1.add_edge (e)
			v4.add_edge (e)
			create e.make (v1, v3)
			v1.add_edge (e)
			v3.add_edge (e)
			sorted_edges := v1.outgoing_sorted
			Result := sorted_edges.count ~ 3
			create sorted_out.make_empty
			across
				sorted_edges as curr_edge
			loop
				sorted_out.append (curr_edge.item.destination.out)
				sorted_out.append (" ")
			end
			assert_equal ("outgoing_sorted_correct", "a:b,c,d", v1.out)
		end

	t17c: BOOLEAN -- outgoing_sorted - Course Basic
		local
			v1, v2, v3, v4: VERTEX [COURSE]
			e: EDGE [COURSE]
			sorted_edges: ARRAY [EDGE [COURSE]]
			sorted_out: STRING
		do
			comment ("t17c: Queries - outgoing_sorted - Course Basic")
			create v1.make (create {COURSE}.make (3001, "Software 1", "F"))
			create v2.make (create {COURSE}.make (3003, "Software 3", "W"))
			create v3.make (create {COURSE}.make (3004, "Software 4", "F"))
			create v4.make (create {COURSE}.make (3002, "Software 2", "W"))
			create e.make (v1, v2)
			v1.add_edge (e)
			v2.add_edge (e)
			create e.make (v1, v4)
			v1.add_edge (e)
			v4.add_edge (e)
			create e.make (v1, v3)
			v1.add_edge (e)
			v3.add_edge (e)
			sorted_edges := v1.outgoing_sorted
			Result := sorted_edges.count ~ 3
			create sorted_out.make_empty
			across
				sorted_edges as curr_edge
			loop
				sorted_out.append (curr_edge.item.destination.out)
				sorted_out.append (" ")
			end
			assert_equal ("outgoing_sorted_correct", "3001:3002,3003,3004", v1.out)
		end

end
