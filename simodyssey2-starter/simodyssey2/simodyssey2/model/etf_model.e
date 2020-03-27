note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MODEL

inherit
	ANY
		redefine
			out
		end

create {ETF_MODEL_ACCESS}
	make

feature {NONE} -- Initialization

    --info: SHARED_INFORMATION

    -- Initialization for `Current'
	make
		do
			create g.make
			create error_msg.make_empty
		end

feature -- model attributes
	g : GALAXY
	play_mode: BOOLEAN
	test_mode: BOOLEAN
	error_msg: STRING
	game_state: INTEGER
	error_state: INTEGER

feature -- model operations
	default_update
			-- Perform update to the model state.
		do

		end

	reset
			-- Reset model state.
		do
			make
		end

feature --Commands
	set_play(b: BOOLEAN)
		do
			play_mode := b
		end

	set_test(b: BOOLEAN)
		do
			test_mode := b
		end

	set_error(msg: STRING)
		do
			error_msg := msg
			error_state := error_state + 1
		end

	initialize_game(a_thresh: INTEGER; j_thresh: INTEGER; m_thresh: INTEGER;
					b_thresh: INTEGER; p_thresh: INTEGER)
		do
			--initialize board with all movable entities
			across
				g.grid as sect
			loop
				sect.item.populate_movable (a_thresh, j_thresh, m_thresh, b_thresh, p_thresh)
			end

			--initialize board with all stationary entities
			--do separate from movable due to random number generator
			g.set_stationary_items
		end


feature -- queries
	out : STRING
		do
			create Result.make_empty
			Result.append (g.out)
		end

end




