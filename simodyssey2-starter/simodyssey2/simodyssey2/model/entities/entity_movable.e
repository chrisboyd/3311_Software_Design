note
	description: "Summary description for {ENTITY_MOVABLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ENTITY_MOVABLE

inherit
	ENTITY_ALPHABET

feature --attributes
	turns_left: INTEGER

feature --commands
	set_turns(i: INTEGER)
		do
			turns_left := i
		end

feature --deferred command
	move(dest: SECTOR)
		deferred
		end

	check_post_move
		deferred
		end

	reproduce
		deferred
		end

	behave
		deferred
		end

end
