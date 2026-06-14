
function __chitter_script_execute(_pos, _grid) {

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
	
	if _grid[# _pos, __chitter_char.script_arg1] == undefined {
		_grid[# _pos, __chitter_char.script]();
		exit;
	}
	
	var _arg_array = [];
	
	for (var i = 0; i < 14; ++i) {
	    var _id = _arg_id[i];
		var _val = _grid[# _pos, _id];
		
		if _val == undefined { break; }
		
		array_push(_arg_array, _val);
		
	}
	
	script_execute_ext(_grid[# _pos, __chitter_char.script], _arg_array);

}