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
			--add_boolean_case(agent t6)
			add_boolean_case(agent t1)
			add_boolean_case(agent t2)
			add_boolean_case(agent t3)
			add_boolean_case(agent t4)
			add_boolean_case(agent t5)

		end

feature -- Tests

	t1: BOOLEAN -- topologically_sorted Basic
			local
				i_g: LIST_GRAPH[INTEGER]
				i_a: ARRAY[TUPLE[INTEGER, INTEGER]]
			do
				comment ("t1: Topo sort gets right number of vertices -- connected")
				i_a := << [1, 2], [1, 3], [3, 4], [3, 5], [5, 6] >>
				i_a.compare_objects
				create i_g.make_from_array (i_a)
				assert_equal ("correct vertices & edges", "[1:2,3][2][3:4,5][4][5:6][6]", i_g.out)

				Result := i_g.topologically_sorted.count ~ 6
				check Result end
			end

	t2: BOOLEAN
		local
				i_g: LIST_GRAPH[INTEGER]
				i_a: ARRAY[TUPLE[INTEGER, INTEGER]]
			do
				comment ("t2: make disconnected correct")
				i_a := << [1, 2], [1, 3], [3, 4], [5, 6] >>
				i_a.compare_objects
				create i_g.make_from_array (i_a)
				assert_equal ("correct vertices & edges", "[1:2,3][2][3:4][4][5:6][6]", i_g.out)
				Result := i_g.vertex_count ~ 6
				check Result end
			end

	t3: BOOLEAN
		local
			v1, v2: VERTEX [INTEGER]
			e1,e2: EDGE [INTEGER]
		do
			comment("t3: Remove edge, show others weren't affected")
			create v1.make (1)
			create v2.make (2)
			create e1.make (v1, v2)
			create e2.make (v2, v1)
			v1.add_edge (e1)
			v1.add_edge (e2)
			v1.remove_edge (e1)
			Result := v1.has_incoming_edge (e2) and (not v1.has_outgoing_edge (e1))
		end

	t4: BOOLEAN -- Reachable Basic
		local
			i_g: LIST_GRAPH [INTEGER]
			v1, v2: VERTEX [INTEGER]
			e1,e2, e3: EDGE [INTEGER]
			reachable: ARRAY [VERTEX [INTEGER]]
		do
			comment ("t4: Reachable")
			create i_g.make_empty
			create v1.make (1)
			create v2.make (2)
			create e1.make (v1, v2)
			create e2.make (v2, v1)

			i_g.add_vertex (v1)
			i_g.add_vertex (v2)
			i_g.add_edge (e1)
			i_g.add_edge (e2)

			reachable := i_g.reachable (v1)
			Result := reachable.count ~ 2
			check
				Result
			end
		end

	t5: BOOLEAN
		local
			i_g: LIST_GRAPH [INTEGER]
			v1, v2: VERTEX [INTEGER]
			e1,e2, e3: EDGE [INTEGER]
			l_comparator: EDGE_COMPARATOR [INTEGER]
		do
			comment ("t5: Add & Remove Commands - remove_edge - Basic Remove Edge")
			create i_g.make_empty
			create l_comparator
			create v1.make (1)
			create v2.make (2)
			create e1.make (v1, v2)
			create e2.make (v2, v1)
			--create e3.make (v2, v2)

			i_g.add_vertex (v1)
			i_g.add_vertex (v2)
			i_g.add_edge (e1)
			i_g.add_edge (e2)
			--i_g.add_edge (e3)
			i_g.remove_edge (e1)

			Result := i_g.edge_count = 1

		end

	t6:BOOLEAN -- Add/remove - Add Edge that doesn't exist in graph, but with source vertex that share the same item but are different than those added into the graph
		local
			i_g: LIST_GRAPH[INTEGER]
			i_v, i_v2: VERTEX[INTEGER]
			i_e: EDGE[INTEGER]
		do
			comment ("t6: Add & Remove Commands - add_edge - destination vertex not in graph (but shares same item)")
			create i_g.make_empty
			across 1 |..| 6 as i loop
				create i_v.make (i.item)
				i_g.add_vertex (i_v)
			end
			create i_e.make (i_g.vertices[1], i_g.vertices[2]) -- (1, 2)
			i_g.add_edge (i_e)
			create i_e.make (i_g.vertices[4], i_g.vertices[3])
			i_g.add_edge (i_e)
			create i_e.make (i_g.vertices[1], i_g.vertices[5])
			i_g.add_edge (i_e)

			assert_equal ("correct vertices & edges", "[1:2,5][2][3][4:3][5][6]", i_g.out)
			Result := i_g.edge_count ~ 3 and i_g.vertex_count ~ 6
			check Result end


			-- Create new vertex for destination (notice it shares the same item as the one in the graph already
			create i_v2.make (3)
			create i_e.make (i_g.vertices[2], i_v2)
			i_g.add_edge (i_e)
			assert_equal ("correct vertices & edges", "[1:2,5][2:3][3][4:3][5][6]", i_g.out)
		end
end
