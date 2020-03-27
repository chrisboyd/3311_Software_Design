note
	description: "Summary description for {EXPLORER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXPLORER

inherit
	ENTITY_MOVABLE

create
	make

feature -- Initialization

	make(i: INTEGER; loc: SECTOR)
			-- Initialization for `Current'.
		do
			item := 'E'
			id := i
			life := 3
			fuel := 3
			landed := False
			location := loc
		end

feature --Attributes
	life: INTEGER
	fuel: INTEGER
	landed: BOOLEAN

feature --Commands
	move(dest: SECTOR)
		do
			--remove from location, add to destination
			location := dest
		end

	check_post_move
		do
		end

	reproduce
		do
		end

	behave
		do
			--print("explorer behave %N")
		end

	land
		require
			not landed
		do
			landed := True
		end

	liftoff
		require
			landed
		do
			landed := False
		end

end
