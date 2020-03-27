note
	description: "Summary description for {BENIGN}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BENIGN

inherit
	ENTITY_MOVABLE

create
	make

feature -- Initialization

	make(i: INTEGER; loc: SECTOR)
			-- Initialization for `Current'.
		do
			item := 'B'
			id := i
			fuel := 3
			repro_interval := 1
			location := loc
		end

feature --attributes
	repro_interval: INTEGER
	fuel: INTEGER

feature --Commands
	move(dest: SECTOR)
		do
		end

	check_post_move
		do
		end

	reproduce
		do
		end

	behave
		do
		end

end
