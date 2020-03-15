note
	description: "Singleton access to the default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	GALAXY_GAME_ACCESS

feature
	m: GALAXY_GAME
		once
			create Result.make (0,0)
		end

invariant
	m = m
end




