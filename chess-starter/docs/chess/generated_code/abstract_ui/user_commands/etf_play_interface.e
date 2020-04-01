note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ETF_PLAY_INTERFACE
inherit
	ETF_COMMAND
		redefine 
			make 
		end

feature {NONE} -- Initialization

	make(an_etf_cmd_name: STRING; etf_cmd_args: TUPLE; an_etf_cmd_container: ETF_ABSTRACT_UI_INTERFACE)
		do
			Precursor(an_etf_cmd_name,etf_cmd_args,an_etf_cmd_container)
			etf_cmd_routine := agent play(?)
			etf_cmd_routine.set_operands (etf_cmd_args)
			if
				attached {INTEGER_32} etf_cmd_args[1] as size
			then
				out := "play(" + etf_event_argument_out("play", "size", size) + ")"
			else
				etf_cmd_error := True
			end
		end

feature -- command precondition 
	play_precond(size: INTEGER_32): BOOLEAN
		do  
			Result := 
				         is_size(size)
					-- (5 <= size) and then (size <= 8)
		ensure then  
			Result = 
				         is_size(size)
					-- (5 <= size) and then (size <= 8)
		end 
feature -- command 
	play(size: INTEGER_32)
		require 
			play_precond(size)
    	deferred
    	end
end
