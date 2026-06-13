function __err_mod(_name, _value) {
	
	static err_start = "*************************************\n";
	static err_chitt = "|| CHITTER ENCOUNTERED AN ERROR!\n";
	static err_warn  = "|| Found an issue while processing tags.\n"	
	static err_mid   = "\n";
	static err_res	 = "|| Please check tag and/or value.\n"
	static err_end   = "*************************************";
		
	var _string = err_start + err_chitt + err_warn + "|| Invalid tag or value :\n" + "|| " + _name + " - " + string(_value) + err_mid + err_res + err_end;
	
	show_error(_string, true);

}

function __err_id(_id) {
	
	static err_start = "*************************************\n";
	static err_chitt = "|| CHITTER ENCOUNTERED AN ERROR!\n";
	static err_warn  = "|| Queue ID does not exist.\n"	
	static err_mid   = "\n";
	static err_res	 = "|| Please change to a valid ID.\n"
	static err_end   = "*************************************";
		
	var _string = err_start + err_chitt + err_warn + "|| Invalid queue ID :\n" + "|| " + _id + err_mid + err_res + err_end;
	
	show_error(_string, true);
}

function __err_list() {
	
	static err_start = "*************************************\n";
	static err_chitt = "|| CHITTER ENCOUNTERED AN ERROR!\n";
	static err_warn  = "|| Found an issue processing list.\n"	
	static err_mid   = "\n";
	static err_res	 = "|| Please check all tags and values.\n"
	static err_end   = "*************************************";
		
	var _string = err_start + err_chitt + err_warn + "|| Undefined list because of tag or value error" + err_mid + err_res + err_end;
	
	show_error(_string, true);
	
}

function __err_font() {
	
	static err_start = "*************************************\n";
	static err_chitt = "|| CHITTER ENCOUNTERED AN ERROR!\n";
	static err_warn  = "|| No font asset defined.\n"
	static err_mid	 = "|| Chitter is not initialised.\n"
	static err_res	 = "|| Please initialise Chitter.\n"
	static err_end   = "*************************************";
		
	var _string = err_start + err_chitt + err_warn + err_mid + err_res + err_end;
	
	show_error(_string, true);
}

