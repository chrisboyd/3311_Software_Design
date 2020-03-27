note
	description: "Summary description for {ENTITY_MOVABLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ENTITY_MOVABLE

inherit
	ENTITY_ALPHABET

feature{NONE}

	gen: RANDOM_GENERATOR_ACCESS

feature --deferred command
	move(x: INTEGER; y: INTEGER)
		deferred
		end

end
