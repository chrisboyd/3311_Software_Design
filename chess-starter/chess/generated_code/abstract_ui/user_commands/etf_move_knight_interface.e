note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ETF_MOVE_KNIGHT_INTERFACE
inherit
	ETF_COMMAND
		redefine 
			make 
		end

feature {NONE} -- Initialization

	make(an_etf_cmd_name: STRING; etf_cmd_args: TUPLE; an_etf_cmd_container: ETF_ABSTRACT_UI_INTERFACE)
		do
			Precursor(an_etf_cmd_name,etf_cmd_args,an_etf_cmd_container)
			etf_cmd_routine := agent move_knight(?)
			etf_cmd_routine.set_operands (etf_cmd_args)
			if
				attached {TUPLE[x: INTEGER_32; y: INTEGER_32]} etf_cmd_args[1] as square
			then
				out := "move_knight(" + etf_event_argument_out("move_knight", "square", square) + ")"
			else
				etf_cmd_error := True
			end
		end

feature -- command precondition 
	move_knight_precond(square: TUPLE[x: INTEGER_32; y: INTEGER_32]): BOOLEAN
		do  
			Result := 
				         is_square(square)
					-- (1 <= square.x) and then (square.x <= 8)
					-- and then (1 <= square.y) and then (square.y <= 8)
		ensure then  
			Result = 
				         is_square(square)
					-- (1 <= square.x) and then (square.x <= 8)
					-- and then (1 <= square.y) and then (square.y <= 8)
		end 
feature -- command 
	move_knight(square: TUPLE[x: INTEGER_32; y: INTEGER_32])
		require 
			move_knight_precond(square)
    	deferred
    	end
end
