function __fade_out(_index, _name, _struct, _grid) {
	
	var _fade_name_id	= _struct[$ $"{_name}_fade_out"];
	var _fade_frames_id = _struct[$ $"{_name}_fade_frames"];
	var _fade_target_id = _struct[$ $"{_name}_fade_target"];
	
	var _fade_frames = _grid[# _index, _fade_frames_id];
	var _fade_target = _grid[# _index, _fade_target_id];
							
	if _fade_frames > _fade_target {
		_grid[# _index, _fade_target_id] = _grid[# _index, _fade_frames_id];
	}
							
	if _fade_frames > 0 {
		_grid[# _index, _fade_frames_id]--;
	}
	
	var _percent = _fade_frames / _fade_target;
	
	if _percent < infinity {
		return _percent
	}
	return 1;
}
