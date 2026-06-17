/// @ignore 
function __reset_to_base(_list, _struct, _grid, _size) {
		
	var _names = struct_get_names(_list);
	var _count = struct_names_count(_list);
	
	for (var g = 0; g < _size; ++g) {
		for (var i = 0; i < _count; ++i) {
			var _name		= _names[i];
			var _index		= _struct[$ _name];
			var _base		= _list[$ _name];
			var _current	= _grid[# g, _index];
			
			if _current != _base {
				_grid[# g, _index] = _base;
			}
		}
	}
}
	