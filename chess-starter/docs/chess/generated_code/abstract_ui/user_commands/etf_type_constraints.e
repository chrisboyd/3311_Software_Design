class
 	 ETF_TYPE_CONSTRAINTS

feature -- type queries 

	is_size(etf_v: INTEGER_32): BOOLEAN 
		require
			comment("etf_v: SIZE = 5 .. 8")
		do
			 Result := 
				(5 <= etf_v) and then (etf_v <= 8)
		ensure
			 Result = 
				(5 <= etf_v) and then (etf_v <= 8)
		end

	is_square(etf_v: TUPLE[x: INTEGER_32; y: INTEGER_32]): BOOLEAN 
		require
			comment("etf_v: SQUARE = TUPLE[x: 1 .. 8; y: 1 .. 8]")
		do
			 Result := 
				         (1 <= etf_v.x) and then (etf_v.x <= 8)
				and then (1 <= etf_v.y) and then (etf_v.y <= 8)
		ensure
			 Result = 
				         (1 <= etf_v.x) and then (etf_v.x <= 8)
				and then (1 <= etf_v.y) and then (etf_v.y <= 8)
		end
feature -- list of enumeratd constants
	enum_items : HASH_TABLE[INTEGER, STRING]
		do
			create Result.make (10)
		end

	enum_items_inverse : HASH_TABLE[STRING, INTEGER_32]
		do
			create Result.make (10)
		end
feature -- query on declarations of event parameters
	evt_param_types_table : HASH_TABLE[HASH_TABLE[ETF_PARAM_TYPE, STRING], STRING]
		local
			play_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
			move_king_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
			move_knight_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
			undo_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
			redo_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
		do
			create Result.make (10)
			Result.compare_objects
			create play_param_types.make (10)
			play_param_types.compare_objects
			play_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("SIZE", create {ETF_INTERVAL_PARAM}.make(5, 8)), "size")
			Result.extend (play_param_types, "play")
			create move_king_param_types.make (10)
			move_king_param_types.compare_objects
			move_king_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("SQUARE", create {ETF_TUPLE_PARAM}.make(<<create {ETF_PARAM_DECL}.make("x", create {ETF_INTERVAL_PARAM}.make(1, 8)), create {ETF_PARAM_DECL}.make("y", create {ETF_INTERVAL_PARAM}.make(1, 8))>>)), "square")
			Result.extend (move_king_param_types, "move_king")
			create move_knight_param_types.make (10)
			move_knight_param_types.compare_objects
			move_knight_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("SQUARE", create {ETF_TUPLE_PARAM}.make(<<create {ETF_PARAM_DECL}.make("x", create {ETF_INTERVAL_PARAM}.make(1, 8)), create {ETF_PARAM_DECL}.make("y", create {ETF_INTERVAL_PARAM}.make(1, 8))>>)), "square")
			Result.extend (move_knight_param_types, "move_knight")
			create undo_param_types.make (10)
			undo_param_types.compare_objects
			Result.extend (undo_param_types, "undo")
			create redo_param_types.make (10)
			redo_param_types.compare_objects
			Result.extend (redo_param_types, "redo")
		end
feature -- query on declarations of event parameters
	evt_param_types_list : HASH_TABLE[LINKED_LIST[ETF_PARAM_TYPE], STRING]
		local
			play_param_types: LINKED_LIST[ETF_PARAM_TYPE]
			move_king_param_types: LINKED_LIST[ETF_PARAM_TYPE]
			move_knight_param_types: LINKED_LIST[ETF_PARAM_TYPE]
			undo_param_types: LINKED_LIST[ETF_PARAM_TYPE]
			redo_param_types: LINKED_LIST[ETF_PARAM_TYPE]
		do
			create Result.make (10)
			Result.compare_objects
			create play_param_types.make
			play_param_types.compare_objects
			play_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("SIZE", create {ETF_INTERVAL_PARAM}.make(5, 8)))
			Result.extend (play_param_types, "play")
			create move_king_param_types.make
			move_king_param_types.compare_objects
			move_king_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("SQUARE", create {ETF_TUPLE_PARAM}.make(<<create {ETF_PARAM_DECL}.make("x", create {ETF_INTERVAL_PARAM}.make(1, 8)), create {ETF_PARAM_DECL}.make("y", create {ETF_INTERVAL_PARAM}.make(1, 8))>>)))
			Result.extend (move_king_param_types, "move_king")
			create move_knight_param_types.make
			move_knight_param_types.compare_objects
			move_knight_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("SQUARE", create {ETF_TUPLE_PARAM}.make(<<create {ETF_PARAM_DECL}.make("x", create {ETF_INTERVAL_PARAM}.make(1, 8)), create {ETF_PARAM_DECL}.make("y", create {ETF_INTERVAL_PARAM}.make(1, 8))>>)))
			Result.extend (move_knight_param_types, "move_knight")
			create undo_param_types.make
			undo_param_types.compare_objects
			Result.extend (undo_param_types, "undo")
			create redo_param_types.make
			redo_param_types.compare_objects
			Result.extend (redo_param_types, "redo")
		end
feature -- comments for contracts
	comment(etf_s: STRING): BOOLEAN
		do
			Result := TRUE
		end
end