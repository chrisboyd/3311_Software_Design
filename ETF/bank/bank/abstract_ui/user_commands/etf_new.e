note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_NEW
inherit
	ETF_NEW_INTERFACE
create
	make
feature -- command
	new(id: STRING)
    	do
			-- perform some update on the model state
			if across model.accounts as cursor	some cursor.item.id ~ id	end	then
				model.set_error("Id " + id + " already exists")
			else
				model.new(id)
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
