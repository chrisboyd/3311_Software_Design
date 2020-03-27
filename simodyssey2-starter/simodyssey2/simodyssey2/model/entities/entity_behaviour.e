note
	description: "Summary description for {ENTITY_BEHAVIOUR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ENTITY_BEHAVIOUR

inherit
	ENTITY_MOVABLE

feature --attributes
	turns_left: INTEGER
	
feature --deferred commands
	behave
		deferred
		end

	check_post
		deferred
		end


end
