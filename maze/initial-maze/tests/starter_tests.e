note
	description: "Summary description for {STARTER_TESTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STARTER_TESTS

inherit
	ES_TEST

create
	make

feature {NONE} -- Initialization

	make
		do
			create maze_generator.make
			add_boolean_case (agent t1)
			add_boolean_case (agent t2)
			add_boolean_case (agent t3)
			add_boolean_case (agent t4)
			add_boolean_case (agent t5)
		end

feature -- Attributes

	maze_generator: MAZE_GENERATOR
	du: DIRECTION_UTILITY

feature -- Tests
		t1: BOOLEAN
			local
				maze_drawer: MAZE_DRAWER
				difficulty: INTEGER
				maze_printout: STRING
			do
				comment ("t1: Test creation of easy difficulty maze")
				difficulty := 1
				create maze_drawer.make (maze_generator.generate_new_maze (difficulty))
				print(maze_drawer.out)
				maze_printout := "[

  +-*-+---+---+---+---+---+---+
  | X                         |
  +   +   +   +---+---+   +   +
  |       |   |       |       |
  +   +---+   +---+   +---+   +
  |   |                   |   |
  +   +   +   +   +---+   +   +
  |   |       |   |       |   |
  +   +   +---+   +   +   +   +
  |       |   |   |           |
  +---+   +   +   +---+   +---+
  |   |   |       |       |   |
  +   +   +   +   +---+   +   +
  |       |                   |
  +---+---+---+---+---+---+- -+

				]"
				Result := maze_drawer.out ~ maze_printout
				check
					Result
				end
			end

		t2: BOOLEAN
			local
				maze_drawer: MAZE_DRAWER
				difficulty: INTEGER
				maze_printout: STRING
			do
				comment ("t2: Test creation of medium difficulty maze")
				difficulty := 2
				create maze_drawer.make (maze_generator.generate_new_maze (difficulty))
				print(maze_drawer.out)
				maze_printout := "[

  +-*-+---+---+---+---+---+---+---+---+---+---+
  | X                 |                       |
  +   +---+   +---+   +---+   +---+   +---+   +
  |   |           |   |   |   |       |   |   |
  +   +---+---+   +   +   +---+   +   +   +   +
  |                   |       |       |       |
  +   +---+   +---+   +   +---+---+---+   +   +
  |       |                   |   |       |   |
  +---+---+   +   +---+---+   +   +   +   +   +
  |   |   |       |                   |       |
  +   +   +   +   +   +   +---+---+---+   +   +
  |       |               |       |       |   |
  +   +   +---+---+   +---+   +---+   +---+   +
  |       |           |       |   |   |       |
  +   +   +---+   +   +---+   +   +   +   +   +
  |   |   |   |   |   |   |           |   |   |
  +   +   +   +---+---+   +---+---+   +---+   +
  |   |   |   |   |                   |       |
  +   +   +   +   +---+---+   +   +   +---+   +
  |                   |       |   |       |   |
  +   +---+   +   +   +   +---+   +   +   +   +
  |       |   |       |                   |   |
  +---+---+---+---+---+---+---+---+---+---+- -+

				]"
				Result := maze_drawer.out ~ maze_printout
				check
					Result
				end
			end

		t3: BOOLEAN
			local
				maze_drawer: MAZE_DRAWER
				difficulty: INTEGER
				maze_printout: STRING
			do
				comment ("t3: Test creation of hard difficulty maze")
				difficulty := 3
				create maze_drawer.make (maze_generator.generate_new_maze (difficulty))
				print(maze_drawer.out)
				maze_printout := "[

  +-*-+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
  | X                                 |                   |   |
  +   +---+   +---+   +---+---+---+   +   +   +---+   +   +   +
  |               |           |   |           |   |   |       |
  +---+---+---+   +---+   +---+   +---+   +   +   +---+   +---+
  |               |           |   |       |           |       |
  +---+---+---+---+---+   +---+   +---+---+   +   +   +---+   +
  |   |       |                   |   |       |           |   |
  +   +   +   +---+   +---+   +---+   +---+---+   +---+---+   +
  |       |   |       |                       |   |   |       |
  +---+---+   +---+---+   +---+---+   +---+   +---+   +   +   +
  |   |           |       |       |       |   |   |           |
  +   +---+   +   +   +   +   +   +   +---+   +   +   +---+---+
  |               |   |       |               |               |
  +   +---+---+   +---+---+---+---+   +   +   +---+---+---+   +
  |       |       |           |   |   |   |                   |
  +---+   +   +---+   +   +   +   +---+---+---+   +---+---+   +
  |                       |   |           |               |   |
  +   +   +   +   +   +---+   +---+   +   +---+   +   +   +   +
  |   |       |           |           |   |               |   |
  +   +   +   +   +   +---+   +---+   +---+---+   +   +   +   +
  |       |           |   |               |   |           |   |
  +   +   +---+   +---+   +   +   +---+   +   +---+---+---+   +
  |       |   |       |       |   |   |           |   |       |
  +---+   +   +---+   +---+   +   +   +   +   +   +   +   +   +
  |               |       |       |       |       |           |
  +   +---+---+   +   +   +   +---+   +---+   +   +---+   +   +
  |   |   |   |       |           |   |       |       |   |   |
  +---+   +   +---+   +---+   +   +   +   +---+   +---+---+   +
  |                   |           |                           |
  +---+---+---+---+---+---+---+---+---+---+---+---+---+---+- -+

				]"
				Result := maze_drawer.out ~ maze_printout
				check
					Result
				end
			end

		t4: BOOLEAN
			local
				maze_drawer: MAZE_DRAWER
				difficulty: INTEGER
				maze_printout: STRING
			do
				comment ("t4: Test player movement in easy maze")
				difficulty := 1
				create maze_drawer.make (maze_generator.generate_new_maze (difficulty))
				maze_printout := "[

  +-*-+---+---+---+---+---+---+
  | X     |                   |
  +---+   +   +   +---+   +---+
  |                   |       |
  +   +---+---+   +   +---+   +
  |   |   |   |   |           |
  +---+   +   +   +   +   +   +
  |   |                   |   |
  +   +---+   +---+---+---+   +
  |                   |   |   |
  +---+   +---+   +   +   +   +
  |   |           |   |       |
  +   +   +   +   +   +   +   +
  |   |   |   |               |
  +---+---+---+---+---+---+- -+

				]"
				Result := maze_drawer.out ~ maze_printout
				check
					Result
				end
				maze_drawer.move_player (du.e)
				maze_drawer.move_player (du.s)
				maze_drawer.move_player (du.e)
				maze_drawer.move_player (du.e)
				maze_drawer.move_player (du.e)
				maze_drawer.move_player (du.s)
				maze_drawer.move_player (du.e)
				maze_drawer.move_player (du.e)
				print(maze_drawer.out)
				maze_printout := "[

  +-*-+---+---+---+---+---+---+
  | * * * |                   |
  +---+ * +   +   +---+   +---+
  |     * * * * * * * |       |
  +   +---+---+   + * +---+   +
  |   |   |   |   | * * * * X |
  +---+   +   +   +   +   +   +
  |   |                   |   |
  +   +---+   +---+---+---+   +
  |                   |   |   |
  +---+   +---+   +   +   +   +
  |   |           |   |       |
  +   +   +   +   +   +   +   +
  |   |   |   |               |
  +---+---+---+---+---+---+- -+

				]"
				Result := maze_drawer.out ~ maze_printout
				check
					Result
				end
			end

		t5: BOOLEAN
			local
				maze_drawer: MAZE_DRAWER
				difficulty: INTEGER
				maze_printout: STRING
			do
				comment ("t5: Test player winning in easy maze")
				difficulty := 1
				create maze_drawer.make (maze_generator.generate_new_maze (difficulty))
				maze_printout := "[

  +-*-+---+---+---+---+---+---+
  | X                         |
  +   +   +---+---+   +   +   +
  |           |       |       |
  +   +   +---+   +---+   +   +
  |       |   |   |       |   |
  +---+---+   +   +   +---+   +
  |   |           |           |
  +   +---+---+   +---+   +   +
  |               |           |
  +---+---+   +   +---+   +   +
  |       |           |       |
  +   +   +---+---+   +   +   +
  |       |           |       |
  +---+---+---+---+---+---+- -+

				]"
				Result := maze_drawer.out ~ maze_printout
				check
					Result
				end
				maze_drawer.move_player (du.e)
				maze_drawer.move_player (du.e)
				maze_drawer.move_player (du.e)
				maze_drawer.move_player (du.e)
				maze_drawer.move_player (du.e)
				maze_drawer.move_player (du.e)
				maze_drawer.move_player (du.s)
				maze_drawer.move_player (du.s)
				maze_drawer.move_player (du.s)
				maze_drawer.move_player (du.s)
				maze_drawer.move_player (du.s)
				maze_drawer.move_player (du.s)
				print(maze_drawer.out)
				maze_printout := "[

  +-*-+---+---+---+---+---+---+
  | * * * * * * * * * * * * * |
  +   +   +---+---+   +   + * +
  |           |       |     * |
  +   +   +---+   +---+   + * +
  |       |   |   |       | * |
  +---+---+   +   +   +---+ * +
  |   |           |         * |
  +   +---+---+   +---+   + * +
  |               |         * |
  +---+---+   +   +---+   + * +
  |       |           |     * |
  +   +   +---+---+   +   + * +
  |       |           |     * |
  +---+---+---+---+---+---+-X-+

				]"
				Result := maze_drawer.out ~ maze_printout
				check
					Result
				end
			end
end
