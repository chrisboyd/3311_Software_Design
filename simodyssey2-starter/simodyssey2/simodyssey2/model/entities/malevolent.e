note
	description: "Summary description for {MALEVOLENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MALEVOLENT

inherit
	ENTITY_MOVABLE

create
	make

feature --Initialization

	make(i: INTEGER; loc: SECTOR)
			-- Initialization for `Current'.
		do
			item := 'M'
			id := i
			fuel := 3
			repro_interval := 1
			location := loc
			life := 1
			create death_msg.make_empty
		end

feature --attributes
	repro_interval: INTEGER

feature --Commands

	reproduce
		do
		end

	behave
		do
		end

	get_name: STRING
		do
			create Result.make_from_string ("Malevolent")
		end

end
