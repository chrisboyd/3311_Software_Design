note
	description: "[
			Directed Graph implemented as Adjacency List 
		    in generic parameter G that is Comparable:
				vertices: LIST[VERTEX[G]]
				edges: ARRAY [EDGE [G]]
				-- commands
				add_edge (e: EDGE [G])
				add_vertex (v: VERTEX [G])
				remove_edge (a_edge: EDGE [G])
				remove_vertex (a_vertex: VERTEX [G])
				
				A vertex has outgoing and incoming edges.
				An edge has a source vertex and destination vertex.
				Vertices and Edges must be attached.
	]"
	ca_ignore: "CA023", "CA005", "CA023: Undeed parentheses", "CA017", "CA107: Empty compound after then part of if"
	author: "JSO and JW"
	note_to_student: "[
			Only modify features that have a `Todo` comment inside of them.
	]"

class
	LIST_GRAPH [G -> COMPARABLE]

inherit

	DEBUG_OUTPUT
		redefine
			out
		end

create
	make_empty, make_from_array

feature {NONE} -- Initialization

	make_empty
			-- create empty graph
		do
			create {LINKED_LIST [VERTEX [G]]} vertices.make
			vertices.compare_objects
		ensure
			cl_empty_graph: is_empty
		end

	get_vertex (g: G): detachable VERTEX [G]
			-- Return the associated vertex object storing `g`, if any.
			-- Note: In the invariant, it is asserted that all vertices are unique.
		do
			across
				vertices as v
			loop
				if v.item.item ~ g then
					Result := v.item
				end
			end
		ensure
			cl_attached: attached Result implies has_vertex (Result) and Result.item ~ g
			cl_not_attached:
					-- the consequence cannot be `has_vertex (create {VERTEX[G]}.make (g))` because
					-- its incoming/outgoing edges are initialized to empty
					-- (which may not be the case of the actual vertex associated with `g`)
				not attached Result implies not (across vertices as l_v some l_v.item ~ create {VERTEX [G]}.make (g) end)
		end

	make_from_array (a: ARRAY [TUPLE [src: G; dst: G]])
			-- Create a new list graph from an array of tuples.
			-- Each tuple specifies an edge.
		require
			a.object_comparison
		local
			l_v1, l_v2: VERTEX [G]
			l_e: EDGE [G]
		do
			create {LINKED_LIST [VERTEX [G]]} vertices.make
			vertices.compare_objects
			across
				a as tuple
			loop
				if attached get_vertex (tuple.item.src) as v1 then
					l_v1 := v1 -- so that we do not reset the `income` and `outgoing` lists of the existing vertex
				else
					create l_v1.make (tuple.item.src)
				end
				if attached get_vertex (tuple.item.dst) as v2 then
					l_v2 := v2 -- so that we do not reset the `income` and `outgoing` lists of the existing vertex
				else
					create l_v2.make (tuple.item.dst)
				end
				create l_e.make (l_v1, l_v2)
				if not has_vertex (l_v1) then
					add_vertex (l_v1)
				end
				if not has_vertex (l_v2) then
					add_vertex (l_v2)
				end
				if not has_edge (l_e) then
					add_edge (l_e)
				end
			end
		ensure
			cl_edges: across a as l_edge all has_edge ([create {VERTEX [G]}.make (l_edge.item.src), create {VERTEX [G]}.make (l_edge.item.dst)]) end
			cl_vertices: across a as l_edge all has_vertex (create {VERTEX [G]}.make (l_edge.item.src)) or has_vertex (create {VERTEX [G]}.make (l_edge.item.dst)) end
		end

feature -- queries

	vertices: LIST [VERTEX [G]]
		-- LIST to hold the vertices in the graph

	vertex_count: INTEGER
			-- number of vertices
		do
			Result := vertices.count
		ensure
			cl_vertex_count: Result = vertices.count
		end

	edge_count: INTEGER
			-- number of outgoing edges
		do
			across
				vertices as l_vertex
			loop
				Result := Result + l_vertex.item.outgoing_edge_count
			end
		ensure
			cl_edge_count: Result = edges.count
		end

	is_empty: BOOLEAN
			-- does the graph contain no vertices?
		do
			Result := vertices.is_empty
		ensure
			comment ("See invariant empty_consistency")
			cl_is_empty: Result = vertices.is_empty
		end

	has_vertex (a_vertex: VERTEX [G]): BOOLEAN
			-- does the graph contain `a_vertex`?
		do
			Result := vertices.has (a_vertex)
		ensure
			cl_has_vertex: Result = vertices.has (a_vertex)
		end

	has_edge (a_edge: EDGE [G]): BOOLEAN
			-- does the graph contain `a_edge`?
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > vertex_count or Result
			loop
				if vertices [i].has_outgoing_edge (a_edge) then
					Result := True
				end
				i := i + 1
			end
		ensure
			cl_has_edge: Result = edges.has (a_edge)
		end

	edges: ARRAY [EDGE [G]]
			-- array of all outgoing edges
		do
			create Result.make_empty
			across
				vertices as l_vertex
			loop
				across
					l_vertex.item.outgoing as l_edge
				loop
					Result.force (l_edge.item, Result.count + 1)
				end
			end
			Result.compare_objects
		ensure
			cl_edges_count: Result.count = edge_count
			cl_edges_membership: across Result as l_edge all has_edge (l_edge.item) end
		end

feature -- Advanced Queries

	reachable (src: VERTEX [G]): ARRAY [VERTEX [G]]
			-- Starting with vertex `src`, return the list of vertices visited via a breadth-first search.
			-- It is required that `outgoing_sorted` is used for each vertex to reach out to its neighbouring vertices,
			-- so that the resulting array is uniquely ordered.
			-- Note. `outgoing_sorted` is somewhat analogous to `adjacent` in the abstract algorithm documentation of BFS.
		require
			cl_existing_source: has_vertex (src)
		local
			-- Include declarations for local variables used here
			queue: QUEUE[VERTEX[G]]
			parent: VERTEX[G]
		do
			create Result.make_empty -- Included for compilation
			--create visited.make_empty
			create {QUEUE [VERTEX [G]]} queue.make_empty
			Result.force (src, Result.count + 1)
			queue.enqueue(src)

			--while there are still vertices to visit,
			--get the outgoing edge lists for each vertice,
			--for any destination edges in outgoing, if they have not
			--been visited add to the queue
			from
			until
				queue.is_empty
			loop
				parent := queue.first
				queue.dequeue
				across
					parent.outgoing_sorted as to_visit
				loop
					if not (Result.has (to_visit.item.destination)) then
						queue.enqueue (to_visit.item.destination)
						Result.force (to_visit.item.destination, Result.count + 1)
					end
				end
			end

		ensure
			cl_valid_vertices: across Result as l_x all has_vertex (l_x.item) end
		end

feature -- commands

	add_vertex (a_vertex: VERTEX [G])
			-- Add `a_vertex` into current graph
		require
			cl_non_existing_vertex: not has_vertex (a_vertex)
		do
			-- Done
			vertices.extend (a_vertex)

		ensure
			cl_add_vertex_membership:  vertices.has (a_vertex)-- Done.

			cl_add_vertex_others_unchanged:
			across
				old vertices as i
			all
				vertices.has (i.item)

			end
			cl_add_vertex_count: vertex_count = old vertex_count + 1
		end


	add_edge (a_edge: EDGE [G])
			-- Add `a_edge` to current graph
		require
			cl_existing_source_vertex: has_vertex (a_edge.source)
			cl_existing_destination_vertex: has_vertex (a_edge.destination)
			cl_non_existing_edge: not has_edge (a_edge)
		local
			src, dst: VERTEX [G]
		do
			src := a_edge.source
			dst := a_edge.destination


			--since vertex.add_edge already adds both incoming and
			--outgoing edges in the case of a self-loop edge
			if src ~ dst then
				src.add_edge (a_edge)
			else
				src.add_edge (a_edge)
				dst.add_edge (a_edge)
			end
			edges.force (a_edge, edges.count + 1)

		ensure
			cl_add_edge_membership: edges.has (a_edge)
			cl_add_edge_others_unchanged:
			across
				old edges as e
			all
				edges.has (e.item)
			end
			cl_add_edge_count: edge_count = old edge_count + 1
		end

	remove_edge (a_edge: EDGE [G])
			-- Remove `a_edge` from current graph
		require
			cl_existing_source_vertex: has_vertex (a_edge.source)
			cl_existing_destination_vertex: has_vertex (a_edge.destination)
			cl_existing_edge: has_edge (a_edge)
		local
			src, dst: VERTEX [G]
			index_remove: INTEGER
		do
			-- Done.
			src := a_edge.source
			dst := a_edge.destination

			--get index of a_edge in edges array
			--I didnt' see a get_index_of or equivalent for arrays
			from
				index_remove := 1
			until

				(a_edge.destination ~ edges.at (index_remove).destination)
					and (a_edge.source ~ edges.at (index_remove).source)
			loop
				index_remove := index_remove + 1
			end

			--swap the last element of edges array to the index of
			--edge to be removed and then remove the tail element
			edges[index_remove] := edges[edges.count]
			edges.remove_tail (1)

			--remove edge from both source and destination vertices
			if src ~ dst then
				src.remove_edge (a_edge)
			else
				src.remove_edge (a_edge)
				dst.remove_edge (a_edge)
			end



		ensure
			cl_remove_edge_count: edges.count = old edge_count - 1
			cl_remove_edge_membership: not has_edge (a_edge)
		end

	remove_vertex (a_vertex: VERTEX [G])
			-- Remove `a_vertex` from current graph
		require
			cl_existing_vertex: has_vertex (a_vertex)
		local
			i_edge: INTEGER
		do
			--go through all vertices in the graph, if a vertex has an
			--edge that starts or ends with a_vertex, remove it
			across
				vertices as vert
			loop
				across
					vert.item.outgoing as out_edge
				loop
					if out_edge.item.destination ~ a_vertex then
						vert.item.remove_edge (out_edge.item)
					end
				end
				across
					vert.item.incoming as in_edge
				loop
					if in_edge.item.source ~ a_vertex then
						vert.item.remove_edge (in_edge.item)
					end
				end
			end

			--remove a_vertex from vertices
			vertices.prune (a_vertex)

			--remove edges connecting to a_vertex from edges array by swapping
			--edge connecting to a_vertex with the end of edges array and then removing the
			--tail of edges array
			from
				i_edge := 1
			until
				i_edge > edges.count
			loop
				if edges[i_edge].source ~ a_vertex or edges[i_edge].destination ~ a_vertex then
					if edges.count = 1 then
						edges.clear_all
					else
						edges[i_edge] := edges[edges.count]
						edges.remove_tail (1)
					end
				end
				i_edge := i_edge + 1
			end


		ensure
			cl_remove_vertex_count: vertex_count = old vertex_count - 1
			cl_remove_vertex_membership: not has_vertex (a_vertex)
		end

feature -- out

	comment (s: STRING): BOOLEAN
			-- Return string representation of current list graph
		do
			Result := true
		end

	debug_output: STRING
			-- Return string representation of current list graph in debugger
		do
				--			Result := out
			Result := ""
			across
				vertices as l_vertex
			loop
				Result := Result + "[" + l_vertex.item.debug_output + "]"
			end
		end

	out: STRING
		do
			Result := ""
			across
				vertices as l_vertex
			loop
				Result := Result + "[" + l_vertex.item.out + "]"
			end
		end

feature -- agent functions

	vertices_edge_count: INTEGER
			-- total number of incoming and outgoing edges of all vertices in `vertices`
			-- Result = (Σv ∈ vertices : v.outgoing_edge_count + v.incoming_edge_count)
		do
			Result := vertices_outgoing_edge_count + vertices_incoming_edge_count
		end

	vertices_outgoing_edge_count: INTEGER
			-- total number of outgoing edges of all vertices in `vertices`
			-- Result = (Σv ∈ vertices : v.outgoing_edge_count)
		do
			Result := {NUMERIC_ITERABLE [VERTEX [G]]}.sumf (vertices, agent  (v: VERTEX [G]): INTEGER
				do
					Result := v.outgoing_edge_count
				end)
		end

	vertices_incoming_edge_count: INTEGER
			-- total number of incoming edges of all vertices in `vertices`
			-- Result = (Σv ∈ vertices : v.incoming_edge_count)
		do
			Result := {NUMERIC_ITERABLE [VERTEX [G]]}.sumf (vertices, agent  (v: VERTEX [G]): INTEGER
				do
					Result := v.incoming_edge_count
				end)
		end

invariant
	empty_consistency: vertices.count = 0 implies edges.count = 0
	vertex_count = vertices.count
	vertices.lower = 1
	unique_vertices: across 1 |..| vertex_count as i all across 1 |..| vertex_count as j all i.item /= j.item implies vertices [i.item] /~ vertices [j.item] end end
	consistency_incoming_outgoing: across vertices is l_vertex all across l_vertex.outgoing is l_edge all l_edge.destination.has_incoming_edge (l_edge) end and across l_vertex.incoming is l_edge all l_edge.source.has_outgoing_edge (l_edge) end end
	consistency_incoming_outgoing2:
			-- ∀e ∈ edges:
			--	   ∧ e ∈ e.source.outgoing
			--	   ∧ e ∈ e.destination.incoming
		across edges as l_edge all l_edge.item.source.has_outgoing_edge (l_edge.item) and l_edge.item.destination.has_incoming_edge (l_edge.item) end
	count_property_symmetry_1: -- (Σv ∈ vertices : v.outgoing_edge_count + v.incoming_edge_count) = 2 * edge_count
		vertices_edge_count = 2 * edge_count
	count_property_symmetry_2: -- (Σv ∈ vertices : v.outgoing_edge_count) = (Σv ∈ vertices : v.incoming_edge_count)
		vertices_outgoing_edge_count = vertices_incoming_edge_count
	self_loops_are_incomng_and_outgoing: across vertices is l_vertex all across l_vertex.incoming is l_edge some l_edge.source ~ l_edge.destination end = across l_vertex.outgoing is l_edge some l_edge.source ~ l_edge.destination end end

end
