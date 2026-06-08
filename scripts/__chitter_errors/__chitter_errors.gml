function __err_mod(_name, _value) {
	
	static err_start = "*************************************\n";
	static err_chitt = "|| CHITTER ENCOUNTERED AN ERROR!\n";
	static err_warn  = "|| Found an issue while processing tags.\n"	
	static err_mid   = "\n";
	static err_res	 = "|| Closing the game as a result.\n"
	static err_end   = "*************************************";
		
	var _string = err_start + err_chitt + err_warn + "|| Invalid tag or value :\n" + "|| " + _name + " - " + string(_value) + err_mid + err_res + err_end;
	
	show_message(_string);
	game_end();
}

function __err_id(_id) {
	
	static err_start = "*************************************\n";
	static err_chitt = "|| CHITTER ENCOUNTERED AN ERROR!\n";
	static err_warn  = "|| Queue ID does not exist.\n"	
	static err_mid   = "\n";
	static err_res	 = "|| Closing the game as a result.\n"
	static err_end   = "*************************************";
		
	var _string = err_start + err_chitt + err_warn + "|| Invalid queue ID :\n" + "|| " + _id + err_mid + err_res + err_end;
	
	show_message(_string);
	game_end();
	
}

function __err_list(_value) {
	
	static err_start = "*************************************\n";
	static err_chitt = "|| CHITTER ENCOUNTERED AN ERROR!\n";
	static err_warn  = "|| Found an issue processing list.\n"	
	static err_mid   = "\n";
	static err_res	 = "|| Closing the game as a result.\n"
	static err_end   = "*************************************";
		
	var _string = err_start + err_chitt + err_warn + "|| Undefined list because of tag or value error" + err_mid + err_res + err_end;
	
	show_message(_string);
	game_end();
	
}

