note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ETF_TRANSFER_INTERFACE
inherit
	ETF_COMMAND
		redefine 
			make 
		end

feature {NONE} -- Initialization

	make(an_etf_cmd_name: STRING; etf_cmd_args: TUPLE; an_etf_cmd_container: ETF_ABSTRACT_UI_INTERFACE)
		do
			Precursor(an_etf_cmd_name,etf_cmd_args,an_etf_cmd_container)
			etf_cmd_routine := agent transfer(? , ? , ?)
			etf_cmd_routine.set_operands (etf_cmd_args)
			if
				attached {STRING} etf_cmd_args[1] as id1 and then attached {STRING} etf_cmd_args[2] as id2 and then attached {VALUE} etf_cmd_args[3] as a_value
			then
				out := "transfer(" + etf_event_argument_out("transfer", "id1", id1) + "," + etf_event_argument_out("transfer", "id2", id2) + "," + etf_event_argument_out("transfer", "a_value", a_value) + ")"
			else
				etf_cmd_error := True
			end
		end

feature -- command precondition 
	transfer_precond(id1: STRING ; id2: STRING ; a_value: VALUE): BOOLEAN
		do  
			Result := 
				comment ("ID = STRING")
		ensure then  
			Result = 
				comment ("ID = STRING")
		end 
feature -- command 
	transfer(id1: STRING ; id2: STRING ; a_value: VALUE)
		require 
			transfer_precond(id1, id2, a_value)
    	deferred
    	end
end
