function __fade_in(_index, _name, _struct, _grid) {
	
	var _fade_name_id	= _struct[$ $"{_name}_fade_in"];
	var _fade_frames_id = _struct[$ $"{_name}_fade_frames"];
	var _fade_target_id = _struct[$ $"{_name}_fade_target"];
	
	var _fade_frames = _grid[# _index, _fade_frames_id];
	var _fade_target = _grid[# _index, _fade_target_id];
							
	if _fade_frames > _fade_target {
		_grid[# _index, _fade_target_id] = _grid[# _index, _fade_frames_id];
	}
							
	if _fade_frames <= 0  {
		_grid[# _index, _fade_name_id] = false;
								
	} else {
		_grid[# _index, _fade_frames_id]--;
	}
	
	var _percent = 1 - _fade_frames / _fade_target
	
	if _percent > -infinity {
		return _percent;	
	}
	
	return 0;
}

function __fade_out(_index, _name, _struct, _grid) {
	
	var _fade_name_id	= _struct[$ $"{_name}_fade_out"];
	var _fade_frames_id = _struct[$ $"{_name}_fade_frames"];
	var _fade_target_id = _struct[$ $"{_name}_fade_target"];
	
	var _fade_frames = _grid[# _index, _fade_frames_id];
	var _fade_target = _grid[# _index, _fade_target_id];
							
	if _fade_frames > _fade_target {
		_grid[# _index, _fade_target_id] = _grid[# _index, _fade_frames_id];
	}
							
	if _fade_frames <= 0  {
		_grid[# _index, _fade_name_id] = false;
								
	} else {
		_grid[# _index, _fade_frames_id]--;
	}
	
	var _percent = _fade_frames / _fade_target;
	
	if _percent < infinity {
		return _percent
	}
	return 1;
}

function __sdf_reset(_struct) {

_struct.thickness			= 0;
_struct.coreColour			= c_white;
_struct.coreAlpha			= 1;
_struct.outlineEnable		= false;
_struct.outlineDistance		= 0;
_struct.outlineColour		= 0;
_struct.outlineAlpha		= 1;
_struct.glowEnable			= false;
_struct.glowStart			= 0;
_struct.glowEnd				= 0;
_struct.glowColour			= 0;
_struct.glowAlpha			= 1;
_struct.dropShadowEnable	= false;
_struct.dropShadowSoftness	= 0;
_struct.dropShadowOffsetX	= 0;
_struct.dropShadowOffsetY	= 0;
_struct.dropShadowColour	= 0;
_struct.dropShadowAlpha		= 1;
	
}