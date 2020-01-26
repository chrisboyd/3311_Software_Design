note
	description: "Summary description for {TEST_LIST_GRAPH_INSTRUCTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	ca_ignore: "CA033", "CA020", "CA085"

class
	TEST_LIST_GRAPH_INSTRUCTOR

inherit

	ES_TEST

create
	make

feature {NONE} -- Initialization

	make
			-- add tests
		do
			add_boolean_case (agent t1)
			add_boolean_case (agent t3)
			add_boolean_case (agent t5)
			add_boolean_case (agent t7)
			add_boolean_case (agent t7b)
			add_boolean_case (agent t8)
			add_boolean_case (agent t8c)
			add_boolean_case (agent t9)
			add_boolean_case (agent t10)
			add_boolean_case (agent t11)
			add_boolean_case (agent t11b)
			add_boolean_case (agent t13)
			add_boolean_case (agent t14)
			add_boolean_case (agent t15)
			add_boolean_case (agent t16b)
			add_boolean_case (agent t16c)
			add_boolean_case (agent t17)
			add_boolean_case (agent t18)
			add_boolean_case (agent t19)
			add_boolean_case (agent t21)
			add_boolean_case (agent t22)
			add_boolean_case (agent t23)
			add_boolean_case (agent t25)
			add_boolean_case (agent t30)
			add_boolean_case (agent t30b)
			add_boolean_case (agent t30c)
			add_boolean_case (agent t31)
			add_boolean_case (agent t32)
			add_boolean_case (agent t34)
			add_boolean_case (agent t35)
			add_boolean_case (agent t37)

		end

feature -- Creation Procedure Tests

	t1: BOOLEAN -- make_empty & make_from_array Basic Integer Case
		local
			i_g: LIST_GRAPH [INTEGER]
			i_a: ARRAY [TUPLE [INTEGER, INTEGER]]
		do
			comment ("t1: Creation Procedures - make_empty & make_from_array - Basic Integer Case")
			create i_g.make_empty
			Result := i_g.vertex_count ~ 0 and i_g.edge_count ~ 0
			check
				Result
			end

				-- make_from_array

			i_a := <<[1, 2], [1, 3], [3, 4], [3, 5], [5, 6]>>
			i_a.compare_objects
			create i_g.make_from_array (i_a)
			assert_equal ("correct vertices & edges", "[1:2,3][2][3:4,5][4][5:6][6]", i_g.out)
			Result := i_g.edge_count ~ 5 and i_g.vertex_count ~ 6
		end

	t3: BOOLEAN -- make_empty & make_from_array Basic String Case
		local
			s_g: LIST_GRAPH [STRING]
			s_a: ARRAY [TUPLE [STRING, STRING]]
		do
			comment ("t3: Creation Procedures - make_empty & make_from_array - Basic String Case")
			create s_g.make_empty
			Result := s_g.vertex_count ~ 0 and s_g.edge_count ~ 0
			check
				Result
			end

				-- make_from_array

			s_a := <<["a", "b"], ["a", "c"], ["c", "d"], ["c", "e"], ["e", "f"]>>
			s_a.compare_objects
			create s_g.make_from_array (s_a)
			assert_equal ("correct vertices & edges", "[a:b,c][b][c:d,e][d][e:f][f]", s_g.out)
			Result := s_g.edge_count ~ 5 and s_g.vertex_count ~ 6
		end

	t5: BOOLEAN -- make_empty & make_from_array Basic Course Case
		local
			c_g: LIST_GRAPH [COURSE]
			c_a: ARRAY [TUPLE [COURSE, COURSE]]
			c1, c2, c3, c4, c5, c6: COURSE
		do
			comment ("t5: Creation Procedures - make_empty & make_from_array - Basic Course Case")
			create c_g.make_empty
			Result := c_g.vertex_count ~ 0 and c_g.edge_count ~ 0
			check
				Result
			end

				-- make_from_array
			create c1.make (2011, "Data Structures", "F")
			create c2.make (2030, "Advanced Object Oriented Programming", "F")
			create c3.make (2031, "Software Tools", "W")
			create c4.make (2200, "Electrical Circuits", "F")
			create c5.make (3311, "Software Design", "F")
			create c6.make (3101, "Design and Analysis of Algorthms", "W")
			c_a := <<[c1, c2], [c1, c3], [c3, c4], [c3, c5], [c5, c6]>>
			c_a.compare_objects
			create c_g.make_from_array (c_a)
			assert_equal ("correct vertices & edges", "[2011:2030,2031][2030][2031:2200,3311][2200][3311:3101][3101]", c_g.out)
			Result := c_g.edge_count ~ 5 and c_g.vertex_count ~ 6
		end

feature -- Add Vertex & Edge Command Tests

	t7: BOOLEAN -- add_vertex - Basic
		local
			i_g: LIST_GRAPH [INTEGER]
			i_v: VERTEX [INTEGER]
			i_e: EDGE [INTEGER]
		do
			comment ("t7: Add & Remove Commands - add_vertex - Basic Integer Case")
			create i_g.make_empty
			across
				1 |..| 6 as i
			loop
				create i_v.make (i.item)
				i_g.add_vertex (i_v)
			end
			assert_equal ("correct vertices & edges", "[1][2][3][4][5][6]", i_g.out)
			Result := true
		end

	t7b: BOOLEAN -- add_vertex, add_edge - Basic
		local
			i_g: LIST_GRAPH [INTEGER]
			i_v: VERTEX [INTEGER]
			i_e: EDGE [INTEGER]
		do
			comment ("t7b: Add & Remove Commands - add_vertex, add_edge - Basic Integer Case")
			create i_g.make_empty
			across
				1 |..| 6 as i
			loop
				create i_v.make (i.item)
				i_g.add_vertex (i_v)
			end
			create i_e.make (i_g.vertices [1], i_g.vertices [2]) -- (1, 2)
			i_g.add_edge (i_e)
			create i_e.make (i_g.vertices [4], i_g.vertices [3])
			i_g.add_edge (i_e)
			create i_e.make (i_g.vertices [1], i_g.vertices [5])
			i_g.add_edge (i_e)
			assert_equal ("correct vertices & edges", "[1:2,5][2][3][4:3][5][6]", i_g.out)
			Result := i_g.edge_count ~ 3 and i_g.vertex_count ~ 6
		end

	t8: BOOLEAN -- add/remove vertices and edges - Self-Loop
		local
			i_g: LIST_GRAPH [INTEGER]
			i_v: VERTEX [INTEGER]
			i_e: EDGE [INTEGER]
		do
			comment ("t8: Add & Remove Commands - add_vertex, add_edge - Self-Loop Integer Case")
			create i_g.make_empty
			across
				1 |..| 6 as i
			loop
				create i_v.make (i.item)
				i_g.add_vertex (i_v)
			end
			create i_e.make (i_g.vertices [1], i_g.vertices [2]) -- (1, 2)
			i_g.add_edge (i_e)
			create i_e.make (i_g.vertices [4], i_g.vertices [3])
			i_g.add_edge (i_e)
			create i_e.make (i_g.vertices [1], i_g.vertices [5])
			i_g.add_edge (i_e)
			assert_equal ("correct vertices & edges", "[1:2,5][2][3][4:3][5][6]", i_g.out)
			Result := i_g.edge_count ~ 3 and i_g.vertex_count ~ 6
			check
				Result
			end

				-- Try adding Self-Loop

			create i_e.make (i_g.vertices [1], i_g.vertices [1])
			i_g.add_edge (i_e)
			assert_equal ("correct vertices & edges", "[1:1,2,5][2][3][4:3][5][6]", i_g.out)
			create i_e.make (i_g.vertices [3], i_g.vertices [3])
			i_g.add_edge (i_e)
			assert_equal ("correct vertices & edges", "[1:1,2,5][2][3:3][4:3][5][6]", i_g.out)
		end

	t8c: BOOLEAN -- add_vertex, add_edge - Self-Loop Course Case
		local
			c_g: LIST_GRAPH [COURSE]
			c_v: VERTEX [COURSE]
			c_e: EDGE [COURSE]
			c1, c2, c3, c4, c5, c6: COURSE
		do
			comment ("t8c: Add & Remove Commands - add_vertex, add_edge - Self-Loop Course Case")
			create c_g.make_empty
			create c1.make (2011, "Data Structures", "F")
			create c2.make (2030, "Advanced Object Oriented Programming", "F")
			create c3.make (2031, "Software Tools", "W")
			create c4.make (2200, "Electrical Circuits", "F")
			create c5.make (3311, "Software Design", "F")
			create c6.make (3101, "Design and Analysis of Algorthms", "W")
			create c_g.make_empty
			Result := c_g.vertex_count ~ 0 and c_g.edge_count ~ 0
			check
				Result
			end
			c_g.add_vertex (create {VERTEX [COURSE]}.make (c1))
			c_g.add_vertex (create {VERTEX [COURSE]}.make (c2))
			c_g.add_vertex (create {VERTEX [COURSE]}.make (c3))
			c_g.add_vertex (create {VERTEX [COURSE]}.make (c4))
			c_g.add_vertex (create {VERTEX [COURSE]}.make (c5))
			c_g.add_vertex (create {VERTEX [COURSE]}.make (c6))
			create c_e.make (c_g.vertices [1], c_g.vertices [2]) -- (1, 2)
			c_g.add_edge (c_e)
			create c_e.make (c_g.vertices [4], c_g.vertices [3])
			c_g.add_edge (c_e)
			create c_e.make (c_g.vertices [1], c_g.vertices [5])
			c_g.add_edge (c_e)
			assert_equal ("correct vertices & edges", "[2011:2030,3311][2030][2031][2200:2031][3311][3101]", c_g.out)
			Result := c_g.edge_count ~ 3 and c_g.vertex_count ~ 6
			check
				Result
			end

				-- Try adding Self-Loop

			create c_e.make (c_g.vertices [1], c_g.vertices [1])
			c_g.add_edge (c_e)
			assert_equal ("correct vertices & edges", "[2011:2011,2030,3311][2030][2031][2200:2031][3311][3101]", c_g.out)
			create c_e.make (c_g.vertices [3], c_g.vertices [3])
			c_g.add_edge (c_e)
			assert_equal ("correct vertices & edges", "[2011:2011,2030,3311][2030][2031:2031][2200:2031][3311][3101]", c_g.out)
		end

	t9: BOOLEAN -- add vertices and edges - Cycle
		local
			i_g: LIST_GRAPH [INTEGER]
			i_v: VERTEX [INTEGER]
			i_e: EDGE [INTEGER]
		do
			comment ("t9: Add & Remove Commands - add_vertex, add_edge - Cycle Integer Case")
			create i_g.make_empty
			across
				1 |..| 6 as i
			loop
				create i_v.make (i.item)
				i_g.add_vertex (i_v)
			end
			create i_e.make (i_g.vertices [1], i_g.vertices [2]) -- (1, 2)
			i_g.add_edge (i_e)
			create i_e.make (i_g.vertices [4], i_g.vertices [3])
			i_g.add_edge (i_e)
			create i_e.make (i_g.vertices [1], i_g.vertices [5])
			i_g.add_edge (i_e)
			assert_equal ("correct vertices & edges", "[1:2,5][2][3][4:3][5][6]", i_g.out)
			Result := i_g.edge_count ~ 3 and i_g.vertex_count ~ 6
			check
				Result
			end

				-- Try adding Cycle
			create i_e.make (i_g.vertices [2], i_g.vertices [4])
			i_g.add_edge (i_e)
			create i_e.make (i_g.vertices [3], i_g.vertices [1])
			i_g.add_edge (i_e)
			assert_equal ("correct vertices & edges", "[1:2,5][2:4][3:1][4:3][5][6]", i_g.out)
		end

feature -- Remove Vertex & Edge Command Tests (Integer)

	t10: BOOLEAN -- Basic Removal of Vertices (not part of edge)
		local
			i_g: LIST_GRAPH [INTEGER]
			i_a: ARRAY [TUPLE [INTEGER, INTEGER]]
			i_v: VERTEX [INTEGER]
		do
			comment ("t10: Add & Remove Commands - remove_vertex - Not part of edge (Integer)")
			i_a := <<[1, 2], [1, 3], [3, 2], [3, 5], [5, 6]>>
			i_a.compare_objects
			create i_g.make_from_array (i_a)
			create i_v.make (10)
			i_g.add_vertex (i_v)
			create i_v.make (4)
			i_g.add_vertex (i_v)
			assert_equal ("correct vertices & edges", "[1:2,3][2][3:2,5][5:6][6][10][4]", i_g.out)
			Result := i_g.edge_count ~ 5 and i_g.vertex_count ~ 7
			check
				Result
			end
			i_g.remove_vertex (i_g.vertices [6])
			assert_equal ("correct vertices & edges", "[1:2,3][2][3:2,5][5:6][6][4]", i_g.out)
			Result := i_g.edge_count ~ 5 and i_g.vertex_count ~ 6
			check
				Result
			end
			i_g.remove_vertex (i_g.vertices [6])
			assert_equal ("correct vertices & edges", "[1:2,3][2][3:2,5][5:6][6]", i_g.out)
			Result := i_g.edge_count ~ 5 and i_g.vertex_count ~ 5
			check
				Result
			end
		end

	t11: BOOLEAN -- Remove Vertex part of edge
		local
			i_g: LIST_GRAPH [INTEGER]
			i_a: ARRAY [TUPLE [INTEGER, INTEGER]]
			i_v: VERTEX [INTEGER]
		do
			comment ("t11: Add & Remove Commands - remove_vertex - Part of edge (Integer)")
			i_a := <<[1, 2], [1, 3], [3, 4], [3, 5], [5, 6], [6, 5]>>
			i_a.compare_objects
			create i_g.make_from_array (i_a)
			create i_v.make (10)
			i_g.add_vertex (i_v)
			assert_equal ("correct vertices & edges", "[1:2,3][2][3:4,5][4][5:6][6:5][10]", i_g.out)
			Result := i_g.edge_count ~ 6 and i_g.vertex_count ~ 7
			check
				Result
			end
			i_g.remove_vertex (i_g.vertices [2])
			assert_equal ("correct vertices & edges", "[1:3][3:4,5][4][5:6][6:5][10]", i_g.out)
			Result := i_g.edge_count ~ 5 and i_g.vertex_count ~ 6
			check
				Result
			end
			i_g.remove_vertex (i_g.vertices [4])
			assert_equal ("correct vertices & edges", "[1:3][3:4][4][6][10]", i_g.out)
			Result := i_g.edge_count ~ 2 and i_g.vertex_count ~ 5
		end

	t11b: BOOLEAN -- Remove Vertex part of edge String
		local
			s_g: LIST_GRAPH [STRING]
			s_a: ARRAY [TUPLE [STRING, STRING]]
			s_v: VERTEX [STRING]
		do
			comment ("t11b: Add & Remove Commands - remove_vertex - Part of edge (String)")
			s_a := <<["a", "b"], ["a", "c"], ["c", "d"], ["c", "e"], ["e", "f"], ["f", "e"]>>
			s_a.compare_objects
			create s_g.make_from_array (s_a)
			create s_v.make ("g")
			s_g.add_vertex (s_v)
			assert_equal ("correct vertices & edges", "[a:b,c][b][c:d,e][d][e:f][f:e][g]", s_g.out)
			Result := s_g.edge_count ~ 6 and s_g.vertex_count ~ 7
			check
				Result
			end
			s_g.remove_vertex (s_g.vertices [2])
			assert_equal ("correct vertices & edges", "[a:c][c:d,e][d][e:f][f:e][g]", s_g.out)
			Result := s_g.edge_count ~ 5 and s_g.vertex_count ~ 6
			check
				Result
			end
			s_g.remove_vertex (s_g.vertices [4])
			assert_equal ("correct vertices & edges", "[a:c][c:d][d][f][g]", s_g.out)
			Result := s_g.edge_count ~ 2 and s_g.vertex_count ~ 5
		end

	t13: BOOLEAN -- Remove last vertex in graph
		local
			i_g: LIST_GRAPH [INTEGER]
			i_a: ARRAY [TUPLE [INTEGER, INTEGER]]
		do
			comment ("t13: Add & Remove Commands - remove_vertex - Remove last vertex in graph")
			i_a := <<[1, 2], [1, 3], [1, 1], [3, 4], [3, 5], [5, 6], [6, 5]>>
			i_a.compare_objects
			create i_g.make_from_array (i_a)
			assert_equal ("correct vertices & edges", "[1:1,2,3][2][3:4,5][4][5:6][6:5]", i_g.out)
			Result := i_g.edge_count ~ 7 and i_g.vertex_count ~ 6
			check
				Result
			end
			i_g.remove_vertex (i_g.vertices [1])
			i_g.remove_vertex (i_g.vertices [1])
			i_g.remove_vertex (i_g.vertices [1])
			i_g.remove_vertex (i_g.vertices [1])
			i_g.remove_vertex (i_g.vertices [1])
			i_g.remove_vertex (i_g.vertices [1])
			assert_equal ("correct vertices & edges", "", i_g.out)
			Result := i_g.edge_count ~ 0 and i_g.vertex_count ~ 0
			check
				Result
			end
		end

	t14: BOOLEAN -- Basic Remove Edge
		local
			i_g: LIST_GRAPH [INTEGER]
			i_a: ARRAY [TUPLE [INTEGER, INTEGER]]
		do
			comment ("t14: Add & Remove Commands - remove_edge - Basic Remove Edge")
			i_a := <<[1, 2], [1, 3], [1, 1], [3, 4], [3, 5], [5, 6], [6, 5]>>
			i_a.compare_objects
			create i_g.make_from_array (i_a)
			assert_equal ("correct vertices & edges", "[1:1,2,3][2][3:4,5][4][5:6][6:5]", i_g.out)
			Result := i_g.edge_count ~ 7 and i_g.vertex_count ~ 6
			check
				Result
			end
			i_g.remove_edge (i_g.vertices [1].outgoing [1]) -- [1] will take out "[1,2]" because outgoing is not sorted
			assert_equal ("correct vertices & edges", "[1:1,3][2][3:4,5][4][5:6][6:5]", i_g.out)
			Result := i_g.edge_count ~ 6 and i_g.vertex_count ~ 6
			check
				Result
			end
		end

	t15: BOOLEAN -- Remove Edge that is a self loop
		local
			i_g: LIST_GRAPH [INTEGER]
			i_a: ARRAY [TUPLE [INTEGER, INTEGER]]
		do
			comment ("t15: Add & Remove Commands - remove_edge - Remove Self Loop Edge")
			i_a := <<[1, 2], [1, 3], [1, 1], [3, 4], [3, 5], [5, 6], [6, 5]>>
			i_a.compare_objects
			create i_g.make_from_array (i_a)
			assert_equal ("correct vertices & edges", "[1:1,2,3][2][3:4,5][4][5:6][6:5]", i_g.out)
			Result := i_g.edge_count ~ 7 and i_g.vertex_count ~ 6
			check
				Result
			end
			i_g.remove_edge (i_g.vertices [1].outgoing [3]) -- [3] because outgoing is not sorted
			assert_equal ("correct vertices & edges", "[1:2,3][2][3:4,5][4][5:6][6:5]", i_g.out)
			Result := i_g.edge_count ~ 6 and i_g.vertex_count ~ 6
			check
				Result
			end
		end

	t16b: BOOLEAN -- Remove last edge in graph String
		local
			s_g: LIST_GRAPH [STRING]
			s_a: ARRAY [TUPLE [STRING, STRING]]
		do
			comment ("t16b: Add & Remove Commands - remove_edge - Remove Last Edge String")
			s_a := <<["a", "b"], ["a", "c"], ["a", "a"], ["c", "d"], ["c", "e"], ["e", "f"], ["f", "e"]>>
			s_a.compare_objects
			create s_g.make_from_array (s_a)
			assert_equal ("correct vertices & edges", "[a:a,b,c][b][c:d,e][d][e:f][f:e]", s_g.out)
			Result := s_g.edge_count ~ 7 and s_g.vertex_count ~ 6
			check
				Result
			end
			s_g.remove_edge (s_g.vertices [1].outgoing [1])
			s_g.remove_edge (s_g.vertices [1].outgoing [1])
			s_g.remove_edge (s_g.vertices [1].outgoing [1])
			s_g.remove_edge (s_g.vertices [3].outgoing [1])
			s_g.remove_edge (s_g.vertices [3].outgoing [1])
			s_g.remove_edge (s_g.vertices [5].outgoing [1])
			s_g.remove_edge (s_g.vertices [6].outgoing [1])
			assert_equal ("correct vertices & edges", "[a][b][c][d][e][f]", s_g.out)
			Result := s_g.edge_count ~ 0 and s_g.vertex_count ~ 6
			check
				Result
			end
		end

	t16c: BOOLEAN -- Remove last edge in graph Course
		local
			c_g: LIST_GRAPH [COURSE]
			c_a: ARRAY [TUPLE [COURSE, COURSE]]
			c1, c2, c3, c4, c5, c6: COURSE
		do
			comment ("t16c: Add & Remove Commands - remove_edge - Remove Last Edge Course")
			create c_g.make_empty
			create c1.make (2011, "Data Structures", "F")
			create c2.make (2030, "Advanced Object Oriented Programming", "F")
			create c3.make (2031, "Software Tools", "W")
			create c4.make (2200, "Electrical Circuits", "F")
			create c5.make (3311, "Software Design", "F")
			create c6.make (3101, "Design and Analysis of Algorthms", "W")
			c_a := <<[c1, c2], [c1, c3], [c1, c1], [c3, c4], [c3, c5], [c5, c6], [c6, c5]>>
			c_a.compare_objects
			create c_g.make_from_array (c_a)
			assert_equal ("correct vertices & edges", "[2011:2011,2030,2031][2030][2031:2200,3311][2200][3311:3101][3101:3311]", c_g.out)
			Result := c_g.edge_count ~ 7 and c_g.vertex_count ~ 6
			check
				Result
			end
			c_g.remove_edge (c_g.vertices [1].outgoing [1])
			c_g.remove_edge (c_g.vertices [1].outgoing [1])
			c_g.remove_edge (c_g.vertices [1].outgoing [1])
			c_g.remove_edge (c_g.vertices [3].outgoing [1])
			c_g.remove_edge (c_g.vertices [3].outgoing [1])
			c_g.remove_edge (c_g.vertices [5].outgoing [1])
			c_g.remove_edge (c_g.vertices [6].outgoing [1])
			assert_equal ("correct vertices & edges", "[2011][2030][2031][2200][3311][3101]", c_g.out)
			Result := c_g.edge_count ~ 0 and c_g.vertex_count ~ 6
			check
				Result
			end
		end

feature -- Basic Query Tests (Integer)

	t17: BOOLEAN -- edges Basic
		local
			i_g: LIST_GRAPH [INTEGER]
			i_a: ARRAY [TUPLE [INTEGER, INTEGER]]
		do
			comment ("t17: Other Queries - edges - Basic")
			i_a := <<[1, 2], [1, 3], [1, 1], [3, 4], [3, 5], [5, 6], [6, 5]>>
			i_a.compare_objects
			create i_g.make_from_array (i_a)
			assert_equal ("correct vertices & edges", "[1:1,2,3][2][3:4,5][4][5:6][6:5]", i_g.out)
			Result := i_g.edge_count ~ 7 and i_g.vertex_count ~ 6
			check
				Result
			end
			Result := i_g.edges.count ~ i_g.edge_count
			check
				Result
			end
			i_g.remove_edge (i_g.vertices [1].outgoing [1])
			Result := i_g.edges.count ~ i_g.edge_count
			check
				Result
			end
			i_g.remove_edge (i_g.vertices [1].outgoing [1])
			Result := i_g.edges.count ~ i_g.edge_count
			check
				Result
			end
			i_g.remove_edge (i_g.vertices [1].outgoing [1])
			Result := i_g.edges.count ~ i_g.edge_count
			check
				Result
			end
			i_g.remove_edge (i_g.vertices [3].outgoing [1])
			Result := i_g.edges.count ~ i_g.edge_count
			check
				Result
			end
			i_g.remove_edge (i_g.vertices [3].outgoing [1])
			Result := i_g.edges.count ~ i_g.edge_count
			check
				Result
			end
			i_g.remove_edge (i_g.vertices [5].outgoing [1])
			Result := i_g.edges.count ~ i_g.edge_count
			check
				Result
			end
			i_g.remove_edge (i_g.vertices [6].outgoing [1])
			Result := i_g.edges.count ~ i_g.edge_count
			check
				Result
			end
			assert_equal ("correct vertices & edges", "[1][2][3][4][5][6]", i_g.out)
			Result := i_g.edge_count ~ 0 and i_g.vertex_count ~ 6
			check
				Result
			end
		end

	t18: BOOLEAN -- vertices
		local
			i_g: LIST_GRAPH [INTEGER]
			i_a: ARRAY [TUPLE [INTEGER, INTEGER]]
		do
			comment ("t18: Other Queries - vertices - Basic")
			i_a := <<[1, 2], [1, 3], [1, 1], [3, 4], [3, 5], [5, 6], [6, 5]>>
			i_a.compare_objects
			create i_g.make_from_array (i_a)
			assert_equal ("correct vertices & edges", "[1:1,2,3][2][3:4,5][4][5:6][6:5]", i_g.out)
			Result := i_g.edge_count ~ 7 and i_g.vertex_count ~ 6
			check
				Result
			end
			Result := i_g.vertices.count ~ i_g.vertex_count
			check
				Result
			end
			i_g.remove_vertex (i_g.vertices [1])
			Result := i_g.vertices.count ~ i_g.vertex_count
			check
				Result
			end
			i_g.remove_vertex (i_g.vertices [1])
			Result := i_g.vertices.count ~ i_g.vertex_count
			check
				Result
			end
			i_g.remove_vertex (i_g.vertices [1])
			Result := i_g.vertices.count ~ i_g.vertex_count
			check
				Result
			end
			i_g.remove_vertex (i_g.vertices [1])
			Result := i_g.vertices.count ~ i_g.vertex_count
			check
				Result
			end
			i_g.remove_vertex (i_g.vertices [1])
			Result := i_g.vertices.count ~ i_g.vertex_count
			check
				Result
			end
			i_g.remove_vertex (i_g.vertices [1])
			assert_equal ("correct vertices & edges", "", i_g.out)
			Result := i_g.edge_count ~ 0 and i_g.vertex_count ~ 0
			check
				Result
			end
		end

	t19: BOOLEAN -- is_empty Basic
		local
			i_g: LIST_GRAPH [INTEGER]
			i_a: ARRAY [TUPLE [INTEGER, INTEGER]]
		do
			comment ("t19: Other Queries - is_empty - Basic")
			i_a := <<[1, 2], [1, 3], [1, 1], [3, 4], [3, 5], [5, 6], [6, 5]>>
			i_a.compare_objects
			create i_g.make_from_array (i_a)
			assert_equal ("correct vertices & edges", "[1:1,2,3][2][3:4,5][4][5:6][6:5]", i_g.out)
			Result := i_g.edge_count ~ 7 and i_g.vertex_count ~ 6
			check
				Result
			end
			Result := not i_g.is_empty
			check
				Result
			end
			i_g.remove_vertex (i_g.vertices [1])
			i_g.remove_vertex (i_g.vertices [1])
			i_g.remove_vertex (i_g.vertices [1])
			i_g.remove_vertex (i_g.vertices [1])
			i_g.remove_vertex (i_g.vertices [1])
			i_g.remove_vertex (i_g.vertices [1])
			Result := i_g.is_empty
			check
				Result
			end
			create i_g.make_empty
			Result := i_g.is_empty
			check
				Result
			end
		end

	t21: BOOLEAN -- has_vertex Basic
		local
			i_g: LIST_GRAPH [INTEGER]
			i_a: ARRAY [TUPLE [INTEGER, INTEGER]]
			v_list: LIST [VERTEX [INTEGER]]
			i_v: VERTEX [INTEGER]
		do
			comment ("t21: Other Queries - has_vertex - Basic")
			i_a := <<[1, 2], [1, 3], [1, 1], [3, 4], [3, 5], [5, 6], [6, 5]>>
			i_a.compare_objects
			create i_g.make_from_array (i_a)
			assert_equal ("correct vertices & edges", "[1:1,2,3][2][3:4,5][4][5:6][6:5]", i_g.out)
			Result := i_g.edge_count ~ 7 and i_g.vertex_count ~ 6
			check
				Result
			end
			v_list := i_g.vertices
			across
				v_list is v
			loop
				Result := i_g.has_vertex (v)
				check
					Result
				end
			end
			create i_v.make (11)
			Result := not i_g.has_vertex (i_v)
			check
				Result
			end
		end

	t22: BOOLEAN -- has_vertex Same Item, different Object (Integer)
		local
			i_g: LIST_GRAPH [INTEGER]
			i_a: ARRAY [TUPLE [INTEGER, INTEGER]]
			i_v: VERTEX [INTEGER]
		do
			comment ("t22: Other Queries - has_vertex - Shares item, but is new object (Integer)")
			i_a := <<[1, 2], [1, 3], [1, 1], [3, 4], [3, 5], [5, 6], [6, 5]>>
			i_a.compare_objects
			create i_g.make_from_array (i_a)
			assert_equal ("correct vertices & edges", "[1:1,2,3][2][3:4,5][4][5:6][6:5]", i_g.out)
			Result := i_g.edge_count ~ 7 and i_g.vertex_count ~ 6
			check
				Result
			end
			create i_v.make (1)
			Result := i_g.has_vertex (i_v) -- the has_vertex query should return true because the graph has a matching vertex with the same item.
			check
				Result
			end
		end

	t22c: BOOLEAN -- has_vertex Same Item, different Object (Course)
		local
			c_g: LIST_GRAPH [COURSE]
			c_a: ARRAY [TUPLE [COURSE, COURSE]]
			c_v: VERTEX [COURSE]
			c1, c2, c3, c4, c5, c6: COURSE
		do
			comment ("t22c: Other Queries - has_vertex - Shares item, but is new object (Course)")
			create c1.make (2011, "Data Structures", "F")
			create c2.make (2030, "Advanced Object Oriented Programming", "F")
			create c3.make (2031, "Software Tools", "W")
			create c4.make (2200, "Electrical Circuits", "F")
			create c5.make (3311, "Software Design", "F")
			create c6.make (3101, "Design and Analysis of Algorthms", "W")
			c_a := <<[c1, c2], [c1, c3], [c1, c1], [c3, c4], [c3, c5], [c5, c6], [c6, c5]>>
			c_a.compare_objects
			create c_g.make_from_array (c_a)
			assert_equal ("correct vertices & edges", "[2011:2011,2030,2031][2030][2031:2200,3311][2200][3311:3101][3101:3311]", c_g.out)
			Result := c_g.edge_count ~ 7 and c_g.vertex_count ~ 6
			check
				Result
			end
			create c_v.make (c1)
			Result := c_g.has_vertex (c_v) -- the has_vertex query should return true because the graph has a matching vertex with the same item.
			check
				Result
			end
		end

	t23: BOOLEAN -- has_edge Basic
		local
			i_g: LIST_GRAPH [INTEGER]
			i_a: ARRAY [TUPLE [INTEGER, INTEGER]]
		do
			comment ("t23: Other Queries - has_edge - Basic")
			i_a := <<[1, 2], [1, 3], [1, 1], [3, 4], [3, 5], [5, 6], [6, 5]>>
			i_a.compare_objects
			create i_g.make_from_array (i_a)
			assert_equal ("correct vertices & edges", "[1:1,2,3][2][3:4,5][4][5:6][6:5]", i_g.out)
			Result := i_g.edge_count ~ 7 and i_g.vertex_count ~ 6
			check
				Result
			end
			across
				i_g.edges is e
			loop
				Result := i_g.has_edge (e)
				check
					Result
				end
			end
		end

	t23b: BOOLEAN -- has_edge Basic String
		local
			s_g: LIST_GRAPH [STRING]
			s_a: ARRAY [TUPLE [STRING, STRING]]
		do
			comment ("t23b: Other Queries - has_edge - Basic String")
			s_a := <<["a", "b"], ["a", "c"], ["a", "a"], ["c", "d"], ["c", "e"], ["e", "f"], ["f", "e"]>>
			s_a.compare_objects
			create s_g.make_from_array (s_a)
			assert_equal ("correct vertices & edges", "[a:a,b,c][b][c:d,e][d][e:f][f:e]", s_g.out)
			Result := s_g.edge_count ~ 7 and s_g.vertex_count ~ 6
			check
				Result
			end
			across
				s_g.edges is e
			loop
				Result := s_g.has_edge (e)
				check
					Result
				end
			end
		end

	t23c: BOOLEAN -- has_edge Basic Course
		local
			c_g: LIST_GRAPH [COURSE]
			c_a: ARRAY [TUPLE [COURSE, COURSE]]
			c1, c2, c3, c4, c5, c6: COURSE
		do
			comment ("t23c: Other Queries - has_edge - Basic Course")
			create c1.make (2011, "Data Structures", "F")
			create c2.make (2030, "Advanced Object Oriented Programming", "F")
			create c3.make (2031, "Software Tools", "W")
			create c4.make (2200, "Electrical Circuits", "F")
			create c5.make (3311, "Software Design", "F")
			create c6.make (3101, "Design and Analysis of Algorthms", "W")
			c_a := <<[c1, c2], [c1, c3], [c1, c1], [c3, c4], [c3, c5], [c5, c6], [c6, c5]>>
			c_a.compare_objects
			create c_g.make_from_array (c_a)
			assert_equal ("correct vertices & edges", "[2011:2011,2030,2031][2030][2031:2200,3311][2200][3311:3101][3101:3311]", c_g.out)
			Result := c_g.edge_count ~ 7 and c_g.vertex_count ~ 6
			check
				Result
			end
			across
				c_g.edges is e
			loop
				Result := c_g.has_edge (e)
				check
					Result
				end
			end
		end

	t25: BOOLEAN -- has_edge Vertices are not in graph, but share same items as ones in it, new edge
		local
			i_g: LIST_GRAPH [INTEGER]
			i_a: ARRAY [TUPLE [INTEGER, INTEGER]]
			i_v1, i_v2: VERTEX [INTEGER]
			i_e: EDGE [INTEGER]
		do
			comment ("t25: Other Queries - has_edge - New Vertices that match existing items, New Edge")
			i_a := <<[1, 2], [1, 3], [1, 1], [3, 4], [3, 5], [5, 6], [6, 5]>>
			i_a.compare_objects
			create i_g.make_from_array (i_a)
			assert_equal ("correct vertices & edges", "[1:1,2,3][2][3:4,5][4][5:6][6:5]", i_g.out)
			Result := i_g.edge_count ~ 7 and i_g.vertex_count ~ 6
			check
				Result
			end
			create i_v1.make (1)
			create i_v2.make (2)
			create i_e.make (i_v1, i_v2)
			Result := i_g.has_edge (i_e) -- Graph does not actually have this edge (vertices match by item with vertices in the graph, but both of them are new)
			check
				Result
			end
		end

feature -- Advanced Query Tests (Integer)

	t30: BOOLEAN -- Reachable Basic
		local
			i_g: LIST_GRAPH [INTEGER]
			i_a: ARRAY [TUPLE [INTEGER, INTEGER]]
			reachable: ARRAY [VERTEX [INTEGER]]
		do
			comment ("t30: Advanced Queries - reachable - Basic Graph, multiple vertices as source")
			i_a := <<[1, 2], [3, 4], [3, 5], [4, 5], [4, 6], [6, 1], [6, 2]>>
			i_a.compare_objects
			create i_g.make_from_array (i_a)
			assert_equal ("correct vertices & edges", "[1:2][2][3:4,5][4:5,6][5][6:1,2]", i_g.out)
			Result := i_g.edge_count ~ 7 and i_g.vertex_count ~ 6
			check
				Result
			end
			reachable := i_g.reachable (i_g.vertices [1])
			Result := reachable.count ~ 2 and reachable [2].item ~ 2
			check
				Result
			end
			reachable := i_g.reachable (i_g.vertices [3])
			Result := reachable.count ~ 6
			check
				Result
			end
		end

	t30b: BOOLEAN -- Reachable Basic String
		local
			s_g: LIST_GRAPH [STRING]
			s_a: ARRAY [TUPLE [STRING, STRING]]
			reachable: ARRAY [VERTEX [STRING]]
		do
			comment ("t30b: Advanced Queries - reachable - Basic String Graph, multiple vertices as source")
			s_a := <<["a", "b"], ["c", "d"], ["c", "e"], ["d", "e"], ["d", "f"], ["f", "a"], ["f", "b"]>>
			s_a.compare_objects
			create s_g.make_from_array (s_a)
			assert_equal ("correct vertices & edges", "[a:b][b][c:d,e][d:e,f][e][f:a,b]", s_g.out)
			Result := s_g.edge_count ~ 7 and s_g.vertex_count ~ 6
			check
				Result
			end
			reachable := s_g.reachable (s_g.vertices [1])
			Result := reachable.count ~ 2 and reachable [2].item ~ "b"
			check
				Result
			end
			reachable := s_g.reachable (s_g.vertices [3])
			Result := reachable.count ~ 6
			check
				Result
			end
		end

	t30c: BOOLEAN -- Reachable Basic Course
		local
			c_g: LIST_GRAPH [COURSE]
			c_a: ARRAY [TUPLE [COURSE, COURSE]]
			reachable: ARRAY [VERTEX [COURSE]]
			c1, c2, c3, c4, c5, c6: COURSE
		do
			comment ("t30c: Advanced Queries - reachable - Basic Course Graph, multiple vertices as source")
			create c1.make (2011, "Data Structures", "F")
			create c2.make (2030, "Advanced Object Oriented Programming", "F")
			create c3.make (2031, "Software Tools", "W")
			create c4.make (2200, "Electrical Circuits", "F")
			create c5.make (3311, "Software Design", "F")
			create c6.make (3101, "Design and Analysis of Algorthms", "W")
			c_a := <<[c1, c2], [c3, c4], [c3, c5], [c4, c5], [c4, c6], [c6, c1], [c6, c2]>>
			c_a.compare_objects
			create c_g.make_from_array (c_a)
			assert_equal ("correct vertices & edges", "[2011:2030][2030][2031:2200,3311][2200:3101,3311][3311][3101:2011,2030]", c_g.out)
			Result := c_g.edge_count ~ 7 and c_g.vertex_count ~ 6
			check
				Result
			end
			reachable := c_g.reachable (c_g.vertices [1])
			Result := reachable.count ~ 2 and reachable [2].item ~ c2
			check
				Result
			end
			reachable := c_g.reachable (c_g.vertices [3])
			Result := reachable.count ~ 6
			check
				Result
			end
		end

	t31: BOOLEAN -- Reachable Disconnected
		local
			i_g: LIST_GRAPH [INTEGER]
			i_a: ARRAY [TUPLE [INTEGER, INTEGER]]
			i_v: VERTEX [INTEGER]
			reachable: ARRAY [VERTEX [INTEGER]]
		do
			comment ("t31: Advanced Queries - reachable - Disconnected Graph")
			i_a := <<[1, 2], [1, 3], [3, 4], [5, 6]>>
			i_a.compare_objects
			create i_g.make_from_array (i_a)
			create i_v.make (10)
			i_g.add_vertex (i_v)
			assert_equal ("correct vertices & edges", "[1:2,3][2][3:4][4][5:6][6][10]", i_g.out)
			Result := i_g.edge_count ~ 4 and i_g.vertex_count ~ 7
			check
				Result
			end
			reachable := i_g.reachable (i_g.vertices [1])
			Result := reachable.count ~ 4 and reachable.has (i_g.vertices [1]) and reachable.has (i_g.vertices [2]) and reachable.has (i_g.vertices [3]) and reachable.has (i_g.vertices [4])
			check
				Result
			end
			reachable := i_g.reachable (i_g.vertices [3])
			Result := reachable.count ~ 2
			check
				Result
			end
			reachable := i_g.reachable (i_g.vertices [7])
			Result := reachable.count ~ 1
			check
				Result
			end
		end

	t32: BOOLEAN -- Reachable Cyclic
		local
			i_g: LIST_GRAPH [INTEGER]
			i_a: ARRAY [TUPLE [INTEGER, INTEGER]]
			i_v: VERTEX [INTEGER]
			reachable: ARRAY [VERTEX [INTEGER]]
		do
			comment ("t32: Advanced Queries - reachable - Cycle")
			i_a := <<[1, 2], [1, 3], [3, 4], [5, 6], [6, 5]>>
			i_a.compare_objects
			create i_g.make_from_array (i_a)
			create i_v.make (10)
			i_g.add_vertex (i_v)
			assert_equal ("correct vertices & edges", "[1:2,3][2][3:4][4][5:6][6:5][10]", i_g.out)
			Result := i_g.edge_count ~ 5 and i_g.vertex_count ~ 7
			check
				Result
			end
			reachable := i_g.reachable (i_g.vertices [6])
			Result := reachable.count ~ 2
			check
				Result
			end
		end

feature -- Object Equal Add/Remove/Has

	t34: BOOLEAN -- add/remove - Remove vertex that shares same item as one in graph, but is a fresh vertex
		local
			i_g: LIST_GRAPH [INTEGER]
			i_v, i_v1: VERTEX [INTEGER]
			i_e: EDGE [INTEGER]
		do
			comment ("t34: Add & Remove Commands - remove_vertex - Vertex shares same item, but not reference equal")
			create i_g.make_empty
			across
				1 |..| 6 as i
			loop
				create i_v.make (i.item)
				i_g.add_vertex (i_v)
			end
			create i_e.make (i_g.vertices [1], i_g.vertices [2]) -- (1, 2)
			i_g.add_edge (i_e)
			create i_e.make (i_g.vertices [4], i_g.vertices [3])
			i_g.add_edge (i_e)
			create i_e.make (i_g.vertices [1], i_g.vertices [5])
			i_g.add_edge (i_e)
			assert_equal ("correct vertices & edges", "[1:2,5][2][3][4:3][5][6]", i_g.out)
			check
				i_g.edge_count ~ 3 and i_g.vertex_count ~ 6
			end
				-- Try removing vertex that isn't in graph, but shares the same item as one in the graph
			create i_v1.make (1)
			i_g.remove_vertex (i_v1)
			assert_equal ("correct vertices & edges", "[2][3][4:3][5][6]", i_g.out) -- it passes this, which mean it correctly removed the corresponding vertex
			Result := i_g.vertex_count ~ 5 and i_g.edge_count ~ 1
		end

	t35: BOOLEAN -- Add/remove - Add Edge that doesn't exist in graph, but with source vertex that share the same item but are different than those added into the graph
		local
			i_g: LIST_GRAPH [INTEGER]
			i_v, i_v1: VERTEX [INTEGER]
			i_e: EDGE [INTEGER]
		do
			comment ("t35:  Add & Remove Commands - add_edge - source vertex not in graph (but shares same item)")
			create i_g.make_empty
			across
				1 |..| 6 as i
			loop
				create i_v.make (i.item)
				i_g.add_vertex (i_v)
			end
			create i_e.make (i_g.vertices [1], i_g.vertices [2]) -- (1, 2)
			i_g.add_edge (i_e)
			create i_e.make (i_g.vertices [4], i_g.vertices [3])
			i_g.add_edge (i_e)
			create i_e.make (i_g.vertices [1], i_g.vertices [5])
			i_g.add_edge (i_e)
			assert_equal ("correct vertices & edges", "[1:2,5][2][3][4:3][5][6]", i_g.out)
			Result := i_g.edge_count ~ 3 and i_g.vertex_count ~ 6
			check
				Result
			end

				-- Create separate source
			create i_v1.make (2)
			create i_e.make (i_v1, i_g.vertices [3])
			i_g.add_edge (i_e)
			assert_equal ("correct vertices & edges", "[1:2,5][2:3][3][4:3][5][6]", i_g.out)
		end

	t37: BOOLEAN -- Remove Vertex part of edge
		local
			i_g: LIST_GRAPH [INTEGER]
			i_a: ARRAY [TUPLE [INTEGER, INTEGER]]
			i_v: VERTEX [INTEGER]
		do
			comment ("t37: Add & Remove Commands - remove_vertex - Part of edge but not reference equal")
			i_a := <<[1, 2], [1, 3], [3, 4], [3, 5], [5, 6], [6, 5]>>
			i_a.compare_objects
			create i_g.make_from_array (i_a)
			create i_v.make (10)
			i_g.add_vertex (i_v)
			assert_equal ("correct vertices & edges", "[1:2,3][2][3:4,5][4][5:6][6:5][10]", i_g.out)
			Result := i_g.edge_count ~ 6 and i_g.vertex_count ~ 7
			check
				Result
			end
			create i_v.make (2)
			i_g.remove_vertex (i_v)
			assert_equal ("correct vertices & edges", "[1:3][3:4,5][4][5:6][6:5][10]", i_g.out)
			Result := i_g.edge_count ~ 5 and i_g.vertex_count ~ 6
			check
				Result
			end
			create i_v.make (5)
			i_g.remove_vertex (i_v)
			assert_equal ("correct vertices & edges", "[1:3][3:4][4][6][10]", i_g.out)
			Result := i_g.edge_count ~ 2 and i_g.vertex_count ~ 5
		end


end
