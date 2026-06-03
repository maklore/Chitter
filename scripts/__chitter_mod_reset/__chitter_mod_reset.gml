/// @ignore 
function __reset_to_base(_struct, _grid, _size) {
		
	static __chitter_base		= new __chitter_base_struct(self);
	static __chitter_base_names = struct_get_names(__chitter_base);
	static __chitter_base_count = struct_names_count(__chitter_base);
		
	for (var g = 0; g < _size; ++g) {
		for (var i = 0; i < __chitter_base_count; ++i) {
			var _name		= __chitter_base_names[i];
			var _index		= _struct[$ _name];
			var _base		= __chitter_base[$ _name];
			var _current	= _grid[# g, _index];

			if _current != _base {
				_grid[# g, _index] = _base;
			}
		}
	}
}
	