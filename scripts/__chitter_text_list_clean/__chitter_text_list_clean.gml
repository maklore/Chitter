/// @ignore
function __text_list_clean(_base, _list) {
	
	
	var _ds_length = ds_list_size(_list);
		
	var _ds_list = ds_list_create();
		
	var _reduction_amount = 0;
		
	var _colours = ["colour", "colour1", "colour2", "colour3", "colour4", 
					"part_colour_mix_1", "part_colour_mix_2", "part_colour1", 
					"part_colour2_1", "part_colour2_2", "part_colour3_1", 
					"part_colour3_2", "part_colour3_3", "sdf_outline_colour",
					"sdf_core_colour", "sdf_outline_colour", "sdf_glow_colour",
					"sdf_shadow_colour", "colour_merge_1", "colour_merge_2"];
	
	for (var i = 0; i < _ds_length - 1; i += 2;) {
		var _start  = _list[| i].start - _reduction_amount;
		var _finish = _list[| i].start + _list[| i + 1].start - _list[| i].finish - _reduction_amount;
		var _names  = _list[| i].modifier;
		var _values = _list[| i].value;
				
		var _arr_length = array_length(_names);

		for (var ii = 0; ii < _arr_length; ++ii;) {
        
		    var _name = _names[ii];
			
			if _values[ii] == "" and is_bool(_base[$ _name]) {
				
				_values[ii] = true;	
				
			} else if _values[ii] == "" { 
				
				__err_mod(_name, _values[ii]); exit; 
				
			}
			
			if _name == "sound_index" or 
				_name == "talker_sprite" or 
				_name == "part_sprite_image" or
				_name == "font" {
					
				if asset_get_index(_values[ii]) == -1 { __err_mod(_name, _values[ii]); exit; }
				
				_values[ii] = asset_get_index(_values[ii]);

				continue;
			}
				
			if _values[ii] == "true" {
				
				_values[ii] = true;
				
				continue;
			}

			if _values[ii] == "false" {
								
				_values[ii] = false;
				
				continue;
			}

		    if array_contains(_colours, _name) {
				
				if string_starts_with(_values[ii], "#") {
					
					if string_length(_values[ii]) != 7 { __err_mod(_name, _values[ii]); exit; }
					
					var _hex = __hex_to_colour(_values[ii]);
					
					_values[ii] = _hex;
					
				} else {
					var _real = _values[ii];
					
					if _real == "" { __err_mod(_name, _real); exit; }
					
					_values[ii] = real(_real);
					
				}
		    } else {
		        var _real = _values[ii];
				
				if string_length(string_letters(_real)) > 0 { __err_mod(_name, _real); exit; }
				
				if string_starts_with(_real, "-") {
					
					_real = string_delete(_real, 1, 1);
					
					_values[ii] = real(-_real);
					
				} else {
					
					_values[ii] = real(_real);
					
				}
		    }
		}
    
		ds_list_add(_ds_list, {
		    start : _start,
		    finish : _finish,
		    names : _names,
		    values : _values
		});

		_reduction_amount += _list[| i].length + 2;
	}
	
	return _ds_list;
};