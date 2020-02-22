note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ETF_NEW_GAME_INTERFACE
inherit
	ETF_COMMAND
		redefine 
			make 
		end

feature {NONE} -- Initialization

	make(an_etf_cmd_name: STRING; etf_cmd_args: TUPLE; an_etf_cmd_container: ETF_ABSTRACT_UI_INTERFACE)
		do
			Precursor(an_etf_cmd_name,etf_cmd_args,an_etf_cmd_container)
			etf_cmd_routine := agent new_game(?)
			etf_cmd_routine.set_operands (etf_cmd_args)
			if
				attached {INTEGER_32} etf_cmd_args[1] as a_level
			then
				out := "new_game(" + etf_event_argument_out("new_game", "a_level", a_level) + ")"
			else
				etf_cmd_error := True
			end
		end

feature -- command precondition 
	new_game_precond(a_level: INTEGER_32): BOOLEAN
		do  
			Result := 
				         is_level(a_level)
					-- (( a_level ~ easy ) or else ( a_level ~ medium ) or else ( a_level ~ hard ))
		ensure then  
			Result = 
				         is_level(a_level)
					-- (( a_level ~ easy ) or else ( a_level ~ medium ) or else ( a_level ~ hard ))
		end 
feature -- command 
	new_game(a_level: INTEGER_32)
		require 
			new_game_precond(a_level)
    	deferred
    	end
end
