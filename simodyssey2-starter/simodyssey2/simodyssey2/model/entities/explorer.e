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
			create death_msg.make_empty
		end

feature --Attributes
	landed: BOOLEAN

feature --Commands

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

	get_name: STRING
		do
			create Result.make_from_string ("Explorer")
		end

end
