class
 	 ETF_TYPE_CONSTRAINTS

feature -- type queries 

	is_level(etf_v: INTEGER_32): BOOLEAN 
		require
			comment("etf_v: LEVEL = {easy, medium, hard}")
		do
			 Result := 
				(( etf_v ~ easy ) or else ( etf_v ~ medium ) or else ( etf_v ~ hard ))
		ensure
			 Result = 
				(( etf_v ~ easy ) or else ( etf_v ~ medium ) or else ( etf_v ~ hard ))
		end

	is_direction(etf_v: INTEGER_32): BOOLEAN 
		require
			comment("etf_v: DIRECTION = {N, E, S, W}")
		do
			 Result := 
				(( etf_v ~ N ) or else ( etf_v ~ E ) or else ( etf_v ~ S ) or else ( etf_v ~ W ))
		ensure
			 Result = 
				(( etf_v ~ N ) or else ( etf_v ~ E ) or else ( etf_v ~ S ) or else ( etf_v ~ W ))
		end

feature -- constants for enumerated items 
	easy: INTEGER =1
	medium: INTEGER =2
	hard: INTEGER =3
	N: INTEGER =4
	E: INTEGER =5
	S: INTEGER =6
	W: INTEGER =7

feature -- list of enumeratd constants
	enum_items : HASH_TABLE[INTEGER, STRING]
		do
			create Result.make (10)
			Result.extend(1, "easy")
			Result.extend(2, "medium")
			Result.extend(3, "hard")
			Result.extend(4, "N")
			Result.extend(5, "E")
			Result.extend(6, "S")
			Result.extend(7, "W")
		end

	enum_items_inverse : HASH_TABLE[STRING, INTEGER_32]
		do
			create Result.make (10)
			Result.extend("easy", 1)
			Result.extend("medium", 2)
			Result.extend("hard", 3)
			Result.extend("N", 4)
			Result.extend("E", 5)
			Result.extend("S", 6)
			Result.extend("W", 7)
		end
feature -- query on declarations of event parameters
	evt_param_types_table : HASH_TABLE[HASH_TABLE[ETF_PARAM_TYPE, STRING], STRING]
		local
			new_game_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
			move_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
			abort_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
			solve_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
		do
			create Result.make (10)
			Result.compare_objects
			create new_game_param_types.make (10)
			new_game_param_types.compare_objects
			new_game_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("LEVEL", create {ETF_ENUM_PARAM}.make(<<"easy", "medium", "hard">>)), "a_level")
			Result.extend (new_game_param_types, "new_game")
			create move_param_types.make (10)
			move_param_types.compare_objects
			move_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("DIRECTION", create {ETF_ENUM_PARAM}.make(<<"N", "E", "S", "W">>)), "a_direction")
			Result.extend (move_param_types, "move")
			create abort_param_types.make (10)
			abort_param_types.compare_objects
			Result.extend (abort_param_types, "abort")
			create solve_param_types.make (10)
			solve_param_types.compare_objects
			Result.extend (solve_param_types, "solve")
		end
feature -- query on declarations of event parameters
	evt_param_types_list : HASH_TABLE[LINKED_LIST[ETF_PARAM_TYPE], STRING]
		local
			new_game_param_types: LINKED_LIST[ETF_PARAM_TYPE]
			move_param_types: LINKED_LIST[ETF_PARAM_TYPE]
			abort_param_types: LINKED_LIST[ETF_PARAM_TYPE]
			solve_param_types: LINKED_LIST[ETF_PARAM_TYPE]
		do
			create Result.make (10)
			Result.compare_objects
			create new_game_param_types.make
			new_game_param_types.compare_objects
			new_game_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("LEVEL", create {ETF_ENUM_PARAM}.make(<<"easy", "medium", "hard">>)))
			Result.extend (new_game_param_types, "new_game")
			create move_param_types.make
			move_param_types.compare_objects
			move_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("DIRECTION", create {ETF_ENUM_PARAM}.make(<<"N", "E", "S", "W">>)))
			Result.extend (move_param_types, "move")
			create abort_param_types.make
			abort_param_types.compare_objects
			Result.extend (abort_param_types, "abort")
			create solve_param_types.make
			solve_param_types.compare_objects
			Result.extend (solve_param_types, "solve")
		end
feature -- comments for contracts
	comment(etf_s: STRING): BOOLEAN
		do
			Result := TRUE
		end
end