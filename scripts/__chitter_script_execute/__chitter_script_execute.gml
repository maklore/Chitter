function __chitter_script_execute(_pos, _grid) {
	
	static _call = gml();
	static _call_scr = asset_get_ids(asset_script);
	static _call_scr_len = array_length(_call_scr);
	
	static _arg_id = [__chitter_char.script_arg1, 
					  __chitter_char.script_arg2, 
					  __chitter_char.script_arg3, 
					  __chitter_char.script_arg4, 
					  __chitter_char.script_arg5, 
					  __chitter_char.script_arg6, 
					  __chitter_char.script_arg7, 
					  __chitter_char.script_arg8, 
					  __chitter_char.script_arg9, 
					  __chitter_char.script_arg10,
					  __chitter_char.script_arg11,
					  __chitter_char.script_arg12,
					  __chitter_char.script_arg13,
					  __chitter_char.script_arg14,
					  __chitter_char.script_arg15];
	
	var _name = _grid[# _pos, __chitter_char.script];
	
	//Call if argument 1 is empty
	if _grid[# _pos, __chitter_char.script_arg1] == undefined {
		
		try {
			
			_call[$ _name]();
			
		} catch(_exception) {
			
			__err_func(_name)
		}
		
		exit;
	}
	
	
	//Add arguments to an array
	var _arg_array = [];
	
	for (var i = 0; i < 14; ++i) {
	    var _id = _arg_id[i];
		var _val = _grid[# _pos, _id];
		
		if _val == undefined { break; }
		
		array_push(_arg_array, _val);
		
	}
	
	//Check if built-in function first.
	if struct_exists(_call, _name) {
				
		script_execute_ext(_call[$ _name], _arg_array);

	} else {

		for (var i = 0; i < _call_scr_len - 1; ++i) {
			
			var _scr_name = script_get_name(_call_scr[i]);

		    if _name == _scr_name {
				
				script_execute_ext(_call_scr[i], _arg_array);
				
				break;
			}
		}
	}

}