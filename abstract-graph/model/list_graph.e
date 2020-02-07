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
	ca_ignore: "CA023", "CA023: Undeed parentheses", "CA017", "CA107: Empty compound after then part of if"
	author: "JSO and JW"
	date: "$Date$"
	revision: "$Revision$"

class
	LIST_GRAPH [G -> COMPARABLE]

inherit

	ITERABLE [VERTEX [G]]
		redefine
			out
		end

	DEBUG_OUTPUT
		redefine
			out
		end

create
	make_empty, make_from_array

feature -- Model

	model: COMPARABLE_GRAPH [VERTEX [G]]
			-- abstraction function
			-- This must be implemented so that the contracts will work properly
			-- You must find a way to translate the `LIST_GRAPH` implementation into the mathematical
			-- model representation of a graph: `COMPARABLE_GRAPH` (which inherits from `GRAPH`).
		local
			l_edge: PAIR[VERTEX[G], VERTEX[G]]
		do
			create Result.make_empty

				-- To Do.
			across
				vertices is v
			loop
				Result.vertex_extend(v)

				across
					v.outgoing is e
				loop
					create l_edge.make (e.source, e.destination)
					Result.edge_extend(l_edge)
				end
			end

		ensure
			comment ("Establishes model consistency invariants")
		end

feature {NONE} -- Initialization

	make_empty
			-- create empty graph
		do
			create {LINKED_LIST [VERTEX [G]]} vertices.make
			vertices.compare_objects
		ensure
			mm_empty_graph: model.is_empty
		end

	get_vertex (g: G): detachable VERTEX [G]
			-- Return the associated vertext object storing `g`, if any.
			-- Note. In the invariant, it is asserted that all vertices are unique.
		do
			-- Done?
			across
				vertices as v
			loop
				if v.item.item ~ g then
					Result := v.item
				end
			end

		ensure
			mm_attached: attached Result implies model.has_vertex (create {VERTEX [G]}.make (g))
			mm_not_attached: not attached Result implies not model.has_vertex (create {VERTEX [G]}.make (g))
		end

	make_from_array (a: ARRAY [TUPLE [src: G; dst: G]])
			-- create a new graph from an array of tuples
			-- each tuple stores contents for the source and the destination
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
			mm_edges:
				-- ∀ [src, dst] ∈ a : [src, dst] ∈ model.edges
				across a as l_edge all
					model.has_edge ([create {VERTEX [G]}.make (l_edge.item.src),
												 create {VERTEX [G]}.make (l_edge.item.dst)])
				end

			mm_vertices:
				-- ∀ [src, dst] ∈ a : src ∈ model.vertices ∧ dst ∈ model.vertices
				across a as l_edge all
					model.has_vertex (create {VERTEX [G]}.make (l_edge.item.src))
					and
					model.has_vertex (create {VERTEX [G]}.make (l_edge.item.dst))
				end
		end

feature -- Iterator Pattern

	new_cursor: ITERATION_CURSOR [VERTEX [G]]
			-- returns a new cursor for current graph
		do
			Result := vertices.new_cursor
		end

feature -- queries

	vertices: LIST [VERTEX [G]]
			-- list of vertices

	vertex_count: INTEGER
			-- number of vertices
		do
			-- Done?
			Result := vertices.count

		ensure
			mm_vertex_count: Result = model.vertex_count
		end

	edge_count: INTEGER
			-- number of outgoing edges
		do
			-- Done?
			across
				vertices as l_vertex
			loop
				Result := Result + l_vertex.item.outgoing_edge_count
			end

		ensure
			mm_edge_count: Result = model.edge_count
		end

	is_empty: BOOLEAN
			-- does the graph contain no vertices?
		do
			-- Done?
			Result := vertices.is_empty

		ensure
			comment ("See invariant empty_consistency")
			mm_is_empty: Result = model.is_empty
		end

	has_vertex (a_vertex: VERTEX [G]): BOOLEAN
			-- does the current graph have `a_vertex`?
		do
			-- Done?
			Result := vertices.has (a_vertex)

		ensure
			mm_has_vertex: Result = model.has_vertex (a_vertex)
		end

	has_edge (a_edge: EDGE [G]): BOOLEAN
			-- does the current graph have `a_edge`?
		local
			i: INTEGER
		do
			-- Done?
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
			mm_has_edge: Result = model.has_edge ([a_edge.source, a_edge.destination])
		end

	edges: ARRAY [EDGE [G]]
			-- array of all outgoing edges
		do
			create Result.make_empty
			-- Done?
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
			mm_edges_count: Result.count = model.edge_count
			mm_edges_membership: across Result as l_edge all model.has_edge ([l_edge.item.source, l_edge.item.destination]) end
		end

feature -- Advanced Queries

	topologically_sorted: ARRAY [VERTEX [G]]
			-- Return an array <<..., vi, ..., vj, ...>> such that
			-- (vi, vj) in edges => i < j
			-- A topological sort is performed.
		require
			is_acyclic: model.is_acyclic
		local
			no_incoming: QUEUE[VERTEX[G]]
			l_vert: LIST[VERTEX [G]]
			curr_vert: VERTEX[G]
			vert: VERTEX[G]
		do
			--Using Kahn's Algorithm
			create Result.make_empty
			Result.compare_objects
			create no_incoming.make_empty
			create {LINKED_LIST [VERTEX [G]]} l_vert.make_from_iterable (vertices)
			l_vert.compare_objects

			--find vertices with no incoming edges
			--and enqueue
			across
				l_vert is v
			loop
				if v.incoming_edge_count = 0 then
					no_incoming.enqueue (v)
				end
			end

			from
			until
				no_incoming.is_empty
			loop
				--get first vertex with zero incoming edges and add to result
				curr_vert := no_incoming.first
				no_incoming.dequeue
				if
					not Result.has(curr_vert)
				then
					Result.force (curr_vert, Result.count + 1)
				end

				--loop through all vertices that have and edge starting at curr_vertex
				--and remove edge
				across
					curr_vert.outgoing_sorted is out_rem
				loop
					curr_vert.remove_edge (out_rem)
					vert := out_rem.destination
					vert.remove_edge (out_rem)
					if vert.incoming_edge_count = 0 then
						Result.force (vert, Result.count + 1)
						no_incoming.enqueue (vert)
					end
				end
			end


		ensure
			mm_sorted: Result ~ model.topologically_sorted.as_array
		end

	is_topologically_sorted (seq: like topologically_sorted): BOOLEAN
			-- does `seq` represent a topological order of the current graph?
		do
			--seq count is same as vertices count
			--all members of seq are in vertices
			--result ordered in ascending edge count
			Result := seq.count ~ vertices.count
			and then
			across
				seq is v
			all
				vertices.has (v)
			end
			and then
			across
				1 |..| seq.count as i
			all
				across
					1 |..| seq.count as j
				all
					i.item = j.item or else (edges.has ([seq[i.item], seq[j.item]]) implies i.item < j.item)
				end
			end
		end

feature -- advanced queries (Lab 1)

	reachable (src: VERTEX [G]): ARRAY [VERTEX [G]]
			-- Starting with vertex `src`, return the list of vertices visited via a breadth-first search.
			-- It is required that `outgoing_sorted` is used for each vertex to reach out to its neighbouring vertices,
			-- so that the resulting array is uniquely ordered.
			-- Note. `outgoing_sorted` is somewhat analogous to `adjacent` in the abstract algorithm documentation of BFS.
		require
			mm_existing_source: model.has_vertex (src)
		local
			-- Include declarations for local variables used here
			queue: QUEUE[VERTEX[G]]
			parent: VERTEX[G]
		do
			--Done?
			create Result.make_empty
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
			Result.compare_objects

		ensure
			mm_reachable_in_model: model.reachable (src).as_array ~ Result
		end

feature -- commands

	add_vertex (a_vertex: VERTEX [G])
			-- adds `a_vertex` to current graph
		require
			mm_non_existing_vertex: not model.has_vertex (a_vertex)
		do
			-- Done?
			vertices.extend (a_vertex)

		ensure
			mm_vertex_added: model ~ (old model.deep_twin) + a_vertex
		end

	 add_edge (a_edge: EDGE [G])
			-- adds `a_edge` to the current graph
		require
			mm_existing_source_vertex: model.has_vertex (a_edge.source)
			mm_existing_destination_vertex: model.has_vertex (a_edge.destination)
			mm_non_existing_edge: not model.has_edge ([a_edge.source, a_edge.destination])
		local
			src, dst: VERTEX [G]
			n_edge: EDGE[G]
		do
			src := a_edge.source
			dst := a_edge.destination
			across
				vertices is v
			loop
				if a_edge.source.item ~ v.item then
					src := v
				end
				if a_edge.destination.item ~ v.item then
					dst := v
				end

			end

			create n_edge.make (src, dst)


			--since vertex.add_edge already adds both incoming and
			--outgoing edges in the case of a self-loop edge
			if src ~ dst then
				src.add_edge (n_edge)
			else
				src.add_edge (n_edge)
				dst.add_edge (n_edge)
			end
			edges.force (n_edge, edges.count + 1)

--				--self loop case
--				if v.item ~ src.item and v.item ~ dst.item then
--					create n_edge.make (v, v)
--					v.add_edge (n_edge)
--				elseif v.item ~ src.item then
--					create n_edge.make (v, dst)
--					v.add_edge (n_edge)
--				elseif  v.item ~ dst.item then
--					create n_edge.make (src, v)
--					v.add_edge (n_edge)
--				end
--				edges.force (a_edge, edges.count + 1)

		ensure
			mm_edge_added: model ~ (old model.deep_twin) |\/| [a_edge.source, a_edge.destination]
		end

	remove_edge (a_edge: EDGE [G])
			-- removes `a_edge` from the current graph
		require
			mm_existing_edge: model.has_edge ([a_edge.source, a_edge.destination])
		local
			src, dst: VERTEX [G]
			index_remove: INTEGER
		do
			-- Done?
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

			across
				vertices is v
			loop
				if v.item ~ src.item and v.item ~ dst.item then
					v.remove_edge (a_edge)
				elseif v.item ~ src.item	then
					v.remove_edge (a_edge)
				elseif v.item ~ dst.item then
					v.remove_edge (a_edge)
				end
			end

		ensure
			mm_edge_removed: model ~ (old model.deep_twin) |\ [a_edge.source, a_edge.destination]
		end

	remove_vertex (a_vertex: VERTEX [G])
			-- removes `a_vertex` from the current graph
		require
			mm_existing_vertex: model.has_vertex (a_vertex)
		local
			i_edge: INTEGER
		do
			-- Done?
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
			mm_vertex_removed: model ~ (old model.deep_twin) - a_vertex
		end

feature -- out

	comment (s: STRING): BOOLEAN
		do
			Result := true
		end

	debug_output: STRING
			-- returns a string representation of current graph
			-- in the debugger
		do
			Result := ""
			across
				vertices as l_vertex
			loop
				Result := Result + "[" + l_vertex.item.debug_output + "]"
			end
		end

	out: STRING
			-- returns a string representation of current graph
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
	empty_consistency:
		vertices.count = 0 implies edges.count = 0
	vertex_count = vertices.count
	vertices.lower = 1
	unique_vertices:
		across 1 |..| vertex_count is i all
		across 1 |..| vertex_count is j all
			i /= j implies vertices [i] /~ vertices [j]
		end end
	consistency_incoming_outgoing:
		across vertices is l_vertex all
			across l_vertex.outgoing is l_edge all
				l_edge.destination.has_incoming_edge (l_edge)
			end
			and
			across l_vertex.incoming is l_edge all
				l_edge.source.has_outgoing_edge (l_edge)
			end
		end
	consistency_incoming_outgoing2:
			-- ∀e ∈ edges:
			--	   ∧ e ∈ e.source.outgoing
			--	   ∧ e ∈ e.destination.incoming
		across edges is l_edge all
			l_edge.source.has_outgoing_edge (l_edge)
			and
			l_edge.destination.has_incoming_edge (l_edge)
		end
	model_consistency_vertex_count:
		model.vertex_count = vertex_count
	model_consistency_edge_count:
		model.edge_count = edge_count
	model_consistency_vertices:
		across model.vertices is l_v all
			has_vertex (l_v)
		end
	model_consistency_edges:
		across model.edges is l_e all
			has_edge ([l_e.first, l_e.second])
		end
	count_property_symmetry_1:
		-- (Σv ∈ vertices : v.outgoing_edge_count + v.incoming_edge_count) = 2 * edge_count
		vertices_edge_count = 2 * edge_count
	count_property_symmetry_2:
		-- (Σv ∈ vertices : v.outgoing_edge_count) = (Σv ∈ vertices : v.incoming_edge_count)
		vertices_outgoing_edge_count = vertices_incoming_edge_count
	self_loops_are_incomng_and_outgoing:
		across vertices is l_vertex all
			across l_vertex.incoming is l_edge some
				l_edge.source ~ l_edge.destination
			end
			=
			across l_vertex.outgoing is l_edge some
				l_edge.source ~ l_edge.destination
			end
		end
end
