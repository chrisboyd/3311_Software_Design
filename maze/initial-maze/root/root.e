note
	description: "[
		ROOT class for maze starter code containing examples of how to use the MAZE classes.
	]"
	author: "CD"
	date: "December 2019"

class
	ROOT

inherit

	ARGUMENTS_32

	ES_SUITE -- testing via ESpec

create
	make

feature {NONE} -- Initialization
	test_mode: BOOLEAN

	make
			-- Run tests or print depending on test_mode
		local
			maze_gen: MAZE_GENERATOR
			maze_draw: MAZE_DRAWER
			difficulty: INTEGER
			du: DIRECTION_UTILITY
			maze_graph: LIST_GRAPH[COORDINATE]
		do
			-- Set test_mode to false
			-- to see output of maze generation in console.
			test_mode := true

			if test_mode then
				add_test(create {STARTER_TESTS}.make)
				show_browser
				run_espec
			else
				-- BASIC MAZE CREATION
				create maze_gen.make -- Create the MAZE_GENERATOR
				difficulty := 1;
				-- Create the MAZE by using the MAZE_GENERATOR.
				-- 1 for easy mode
				maze_graph := maze_gen.generate_new_maze (difficulty)
				create maze_draw.make (maze_graph)
				print("%NPrintout of the intial state of an easy game.")
				print(maze_draw.out) -- Print it out in its initial state

				maze_draw.move_player (du.e)
				maze_draw.move_player (du.e)
				maze_draw.move_player (du.s)
				maze_draw.move_player (du.s)
				print("%NPrintout of the game after some movement.")
				print(maze_draw.out) -- Print out after some moves

				maze_draw.move_player (du.e)
				maze_draw.move_player (du.e)
				maze_draw.move_player (du.e)
				maze_draw.move_player (du.s)
				maze_draw.move_player (du.s)
				maze_draw.move_player (du.s)
				maze_draw.move_player (du.s)
				maze_draw.move_player (du.e)
				print("%NPrintout of the winning game state.")
				print(maze_draw.out) -- Print the winning game state

				difficulty := 2 -- This will make an 11x11 maze
				maze_graph := maze_gen.generate_new_maze (difficulty)
				create maze_draw.make (maze_graph)
				print("%NPrintout of the initial state of a medium maze.")
				print(maze_draw.out)

				maze_draw.move_player (du.s)
				maze_draw.move_player (du.s)
				maze_draw.move_player (du.s)
				maze_draw.move_player (du.e)
				print("%NPrintout of the medium maze after some movement.")
				print(maze_draw.out)

				maze_draw.move_player (du.w)
				print("%NPrintout of the game after backtracking.")
				print(maze_draw.out)

				-- different graph of difficulty = 2
				maze_graph := maze_gen.generate_new_maze (difficulty)
				create maze_draw.make (maze_graph)
				print(maze_draw.out)
			end

		end

end
