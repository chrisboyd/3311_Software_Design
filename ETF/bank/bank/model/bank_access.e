note
	description: "Singleton access to the default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	BANK_ACCESS

feature
	m: BANK
		once
			create Result.make
		end

invariant
	m = m
end




