function __err_mod(_name, _value) {
	
	static err_start = "*************************************\n";
	static err_warn  = "|| Found an issue while processing tags.\n"	
	static err_mid   = "\n";
	static err_res	 = "|| Closing the game as a result.\n"
	static err_end   = "*************************************";
		
	var _string = err_start + err_warn + "|| Invalid tag or value :\n" + "|| " + _name + " - " + string(_value) + err_mid + err_res + err_end;
	
	show_message(_string);
	game_end();
	
}

function __err_id(_id) {
	
	static err_start = "*************************************\n";
	static err_warn  = "|| Found an issue retrieving queue ID.\n"	
	static err_mid   = "\n";
	static err_res	 = "|| Closing the game as a result.\n"
	static err_end   = "*************************************";
		
	var _string = err_start + err_warn + "|| Invalid queue ID :\n" + "|| " + _id + err_mid + err_res + err_end;
	
	show_message(_string);
	game_end();
	
}

