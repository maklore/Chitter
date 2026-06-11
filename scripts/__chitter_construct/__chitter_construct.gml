//Feather ignore all
function __chitter() constructor {
	
	__game_speed_fps = game_get_speed(gamespeed_fps);
	__game_speed_ms  = game_get_speed(gamespeed_microseconds);
	__grid_size = 10_000;
	__grid = ds_grid_create(__grid_size, __chitter_char.length);
	
	__chitter_queue = {};
	
	__part_id  = ds_list_create();
	__part_system = part_system_create();
	part_system_draw_order(__part_system, true);
	part_system_automatic_draw(__part_system, false);
	
	__font = undefined;
	__font_name = undefined;
	__font_sprite = undefined;
	__font_sprite_struct = {};
	__font_draw_each = false;
	__font_scale_base = 1;
	__font_width_base = 0;
	__font_height_base = 0;
	__font_colour_base = 0;
	__font_colour_base_red   = 0;
	__font_colour_base_green = 0;
	__font_colour_base_blue  = 0;
	__font_colour_base_hue   = 0;
	__font_colour_base_sat   = 0;
	__font_colour_base_val   = 0;
	
	__sound = undefined;
	__write_pos = 0;
	__floor_pos = 0;
	__string_pos = 0;
	__next = false;
	__string_current = "";
	__string_draw = "";
	__string_length = 0;
	__string_count = 0;
	__draw_mods = true;
		
	static __chitter_struct = new __chitter_enum_struct();
	static __chitter_premod = new __chitter_premods();
	
	__chitter_struct_names  = struct_get_names(__chitter_struct);
	__chitter_struct_count  = struct_names_count(__chitter_struct);
	__chitter_premod_names  = struct_get_names(__chitter_premod);
	__chitter_premod_count  = struct_names_count(__chitter_premod);
	__chitter_base = undefined;
	
	//Sort premod array by string length in descending order
	array_sort(__chitter_premod_names, function(_current, _next) {
			return string_length(_next) - string_length(_current);
	});

	/**
	Initialises Chitter.
	*
	@param {ASSET.GMFont} _fontASSET Base font.
	@param {Constant.colour or Real} _fontColour Base font colour.
	@param {ASSET.GMSound} _sound Base sound.
	@param {Bool} _fontDrawEach Set true if using a non monospace font.
	*/
	static initialise = function(_fontASSET, _fontColour, _soundASSET = undefined, _fontDrawEach = false) {
		
		//Init base.
		__font					 = _fontASSET;
		__font_name				 = font_get_name(_fontASSET);
		__font_draw_each		 = _fontDrawEach;
		__font_colour_base		 = _fontColour;
		__font_colour_base_red   = colour_get_red(__font_colour_base);
		__font_colour_base_green = colour_get_green(__font_colour_base);
		__font_colour_base_blue  = colour_get_blue(__font_colour_base);
		__font_colour_base_hue   = colour_get_hue(__font_colour_base);
		__font_colour_base_sat   = colour_get_saturation(__font_colour_base);
		__font_colour_base_val   = colour_get_value(__font_colour_base);
		
		__sound = _soundASSET;
		
		draw_set_font(_fontASSET);
		
		__font_width_base = string_width("W");
		__font_height_base = string_height("|");
				
		//Get all font assets
		//Create a sprite for each letter for font assets.
		//And set base font sprite.
		var _font_ids = asset_get_ids(asset_font);
		var _font_count = array_length(_font_ids);
		var _i = 0;

		for (var i = 0; i < _font_count; ++i) {
			
			var _id	  = _font_ids[_i];
			var _name = font_get_name(_id);
			
			__font_sprite_struct[$ _name] = __font_to_spr(_id, 33, 128);
			
		}
		
		__font_sprite = __font_sprite_struct[$ __font_name];		
		
		__chitter_base = new __chitter_base_struct(self);
		
	}
		
	/**
	Add name, modified string, and sprite of the talker to a queue system. 
	*
	@param {string} _id Queue ID.
	@param {string} _name Name of the talker.
	@param {string} _string String or modified string of the talker.
	@param {ASSET.GMSprite} _sprite Sprite of the talker.
	*/
	static add = function(_id, _name, _string, _sprite = undefined) {

		if __font == undefined { __err_font(); }
		
		if !struct_exists(__chitter_queue, _id) {
			__chitter_queue[$ _id] = {
				__string_list : ds_list_create(),
				__part_id : ds_list_create(),
				__grid : ds_list_create()
			}
		}
				
		var _queue = __chitter_queue[$ _id];
		
		var _text_list	 = __text_parse(_string);
		var _string_list = __text_clean(__string_current, _text_list);
		var _mod_list   = __text_list_clean(__chitter_base, _text_list);
		
		var _list_size   = ds_list_size(_queue.__string_list);
		
		var _clean_list = __text_parse_second(_string);
		var _clean_text = __text_clean(_string, _clean_list);
		
		ds_list_add(_queue.__grid, ds_grid_create(string_length(_clean_text) + 1, __chitter_char.length));
		ds_list_add(_queue.__part_id, ds_list_create());
		
		if _text_list == undefined or _mod_list == undefined or _clean_list == undefined {
			__err_list();
		}
	
		__text_gridify(_queue.__grid[| _list_size], _name, _sprite, _clean_text);
		__text_modify(_queue.__grid[| _list_size], _queue.__part_id[| _list_size], _mod_list);

		ds_list_add(_queue.__string_list, _clean_text);
			
		__string_length = 0;
		__string_current = "";
		
		ds_list_destroy(_text_list);
		ds_list_destroy(_mod_list);
		ds_list_destroy(_clean_list);
				
		return self;
	}
	
	/**
	Sends the modified string from the queue to be drawn, and removes it from the queue.
	
	Returns -1 if there are no more strings in the queue.
	Returns 0 if typewriter skip is triggered.
	Returns 1 if new string is sent to draw.
	*
	@param {string} _id Queue ID.
	*/
	static next = function(_id) {
				
		if !struct_exists(__chitter_queue, _id) {
			__err_id(_id);
		}

		var __queue = __chitter_queue[$ _id];
				
		if __write_pos >= __string_length and ds_list_size(__queue.__string_list) == 0 {
			__next = false;
			return -1;
		}
		
		//Delete previous particles safely.
		if __write_pos >= __string_length and ds_list_size(__queue.__string_list) < ds_list_size(__queue.__part_id) {
			var _i = 0;
			var _part_count = ds_list_size(__queue.__part_id[| 0]);
			repeat _part_count {
				part_type_destroy(__queue.__part_id[| 0][| _i]);
				_i++;
			}
			ds_list_delete(__queue.__part_id, 0);
		}
		
		//If position is less than length, draw the rest.
		if __write_pos < __string_length {
			__write_pos = __string_length;
			
			__text_skip_typewriter();
			__next = true;
			
			return 0;
			
		}
		
		__next = true;
		__draw_mods = true;
		__write_pos = 0;
		__string_pos = 0;
		__floor_pos = 0;
		__string_draw = "";	
		
		//Fetch oldest data from queue.
		__string_length = string_length(__queue.__string_list[| 0]);
		__string_count = __string_length - string_count(chr(32), __queue.__string_list[| 0]);
		
		ds_grid_copy(__grid, __queue.__grid[| 0]);
		
		__part_id = __queue.__part_id[| 0];

		//Delete oldest data from queue.
		ds_list_delete(__queue.__string_list, 0);
		
		//Delete grid from memory before deleting the ds_list
		ds_grid_destroy(__queue.__grid[| 0])
		
		ds_list_delete(__queue.__grid, 0);
		
		return 1;
	};
	
	/**
	Returns true if queue is empty.
	*
	@param {string} _id Queue ID.
	*/
	static queue_empty = function(_id) {

		if !struct_exists(__chitter_queue, _id) {
			__err_id(_id);
		}
		var __queue = __chitter_queue[$ _id];

		return (ds_list_size(__queue.__string_list) == 0);

	}

	/**
	Returns current active talker name set in .add() or added through modifier tags, else returns 0.
	*/
	static talker = function() {
		if !__next { return 0; }
		return __grid[# __floor_pos, __chitter_char.talker];
	}
	
	/**
	Returns current active talker sprite set in .add() or added through modifier tags, else returns 0.
	*/
	static sprite = function() {
		if !__next { return 0; }
		return __grid[# __floor_pos, __chitter_char.talker_sprite];
	}
		
	/**
	Removes all font sprites created at `.initialise()` from memory.
	*/
	static cleanup = function() {		
		
		if struct_names_count(__font_sprite_struct) > 0 {
			struct_foreach(__font_sprite_struct, function(_key) {
				if sprite_exists(__font_sprite_struct[$ _key]) {
					sprite_delete(__font_sprite_struct[$ _key]);
				}
				struct_remove(__font_sprite_struct, _key);
			});
		}
	}
	
	/**
	Draws the active modified string.
	*
	@param {real} _x X position of modified string to be drawn.
	@param {real} _y Y position of modified string to be drawn.
	*/
	static draw = function(_x, _y) {

		static _i = 0,
		       _ord = 0,
			   _x_return = 0,
			   _y_return = 0,
			   _xx = 0, 
			   _yy = 0,
			   _scale_x = 1,
			   _scale_y = 1,
			   _angle = 0,
			   _colour1 = 255,
			   _colour2 = 255,
			   _colour3 = 255,
			   _colour4 = 255,
			   _alpha = 1,
			   _hue = 0,
			   _sat = 255,
			   _val = 255,
			   _particles = false,
			   _part_id = -1,
			   _part_type = -1,
			   _part_count = 1,
			   _part_x_return = 0,
			   _part_y_return = 0,
			   _sdf_params = {
				thickness			: 0,
				coreColour			: c_white,
				coreAlpha			: 1,
				outlineEnable		: false,
				outlineDistance		: 0,
				outlineColour		: 0,
				outlineAlpha		: 1,
				glowEnable			: false,
				glowStart			: 0,
				glowEnd				: 0,
				glowColour			: 0,
				glowAlpha			: 1,
				dropShadowEnable	: false,
				dropShadowSoftness	: 0,
				dropShadowOffsetX	: 0,
				dropShadowOffsetY	: 0,
				dropShadowColour	: 0,
				dropShadowAlpha		: 1
			   };

		if !__next { exit; }
		
		//Write each letter
		if __write_pos < __string_length {
			
			if __grid[# __floor_pos, __chitter_char.wait_frames] > 0 {
				__grid[# __floor_pos, __chitter_char.wait_frames] -= 1;
			}
			
			if __grid[# __floor_pos, __chitter_char.wait_seconds] > 0 {
				__grid[# __floor_pos, __chitter_char.wait_seconds] -= 1 / __game_speed_fps;
			}
			
			if __grid[# __floor_pos, __chitter_char.wait_frames] <= 0 and __grid[# __floor_pos, __chitter_char.wait_seconds] <= 0 {
			
				var _write_speed = __grid[# __floor_pos, __chitter_char.write_speed] / __game_speed_fps;
			
				__write_pos += _write_speed;
			
				var _float_pos = floor((__write_pos + 0.01) / 0.02) * 0.02;

				__floor_pos = floor(_float_pos); 
			
				if __string_pos < __floor_pos {
				
					var _char = __grid[# __string_pos, __chitter_char.char];
				
					if !__font_draw_each {
						__string_draw = !__grid[# __string_pos, __chitter_char.chmod] ? __string_draw + _char : __string_draw + chr(32);
					}
				
					if __sound != undefined and _char != chr(10) and _char != chr(13) { 
						var _index		= __grid[# __string_pos, __chitter_char.sound_index];
						var _priority	= __grid[# __string_pos, __chitter_char.sound_priority];
						var _loops		= __grid[# __string_pos, __chitter_char.sound_loop];
						var _gain		= __grid[# __string_pos, __chitter_char.sound_gain_random]   ? random_range(__grid[# __string_pos, __chitter_char.sound_gain_low],   __grid[# __string_pos, __chitter_char.sound_gain_high])   : __grid[# __string_pos, __chitter_char.sound_gain];
						var _offset		= __grid[# __string_pos, __chitter_char.sound_offset_random] ? random_range(__grid[# __string_pos, __chitter_char.sound_offset_low], __grid[# __string_pos, __chitter_char.sound_offset_high]) : __grid[# __string_pos, __chitter_char.sound_offset];
						var _pitch		= __grid[# __string_pos, __chitter_char.sound_pitch_random]  ? random_range(__grid[# __string_pos, __chitter_char.sound_pitch_low],  __grid[# __string_pos, __chitter_char.sound_pitch_high])  : __grid[# __string_pos, __chitter_char.sound_pitch];
						var _mask		= __grid[# __string_pos, __chitter_char.sound_listener_mask];
						if _index > 0 {
							audio_play_sound(_index, _priority, _loops, _gain, _offset, _pitch);
						}
					}
				
					__string_pos = __floor_pos;
				}
			}
		}
		
		//If there are no modifiers active, disable loop.
		if __draw_mods and __floor_pos == __string_length and (__string_length - string_count(chr(32), __string_draw)) == __string_count {
			__draw_mods = false;	
		}
		
		//Process mods and draw
		if __draw_mods {

			draw_set_font(__font);
			draw_set_halign(fa_left);
			draw_set_valign(fa_middle);
		
			var _time = current_time * (pi * 2);
			
			var _active = 0;
			
			//Spawn particles
			for (var i = 0; i < __string_pos; ++i) {
				
				if __grid[# i, __chitter_char.hard_stop_frames] > 0 {
						
					__grid[# i, __chitter_char.hard_stop_frames] -= 1;
						
					if __grid[# i, __chitter_char.hard_stop_frames] <= 0 {
							
						for (var i = 0; i < __string_length; ++i) {
								
							__grid[# i, __chitter_char.chmod] = false;
					
							if i < __string_length  {
									 
								__string_draw = string_delete(__string_draw, i + 1, 1);
								__string_draw = string_insert(__grid[# i, __chitter_char.char], __string_draw, i + 1);
							}
						}
							
						__draw_mods = false

					}
					
				}
					
				if __grid[# i, __chitter_char.hard_stop_seconds] > 0 {
						
					__grid[# i, __chitter_char.hard_stop_seconds] -= 1 / __game_speed_fps;
						
					if __grid[# i, __chitter_char.hard_stop_seconds] <= 0 {
							
						for (var i = 0; i < __string_length; ++i) {
								
							__grid[# i, __chitter_char.chmod] = false;
					
							if i < __string_length {
					
								__string_draw = string_delete(__string_draw, i + 1, 1);
								__string_draw = string_insert(__grid[# i, __chitter_char.char], __string_draw, i + 1);
							}
						}
							
						__draw_mods = false

					}
						
				}
				
				var _modified = __grid[# i, __chitter_char.chmod];
			
				if _modified or __font_draw_each {
				
					_xx =	  __grid[# i, __chitter_char.width];
					_yy =	  __grid[# i, __chitter_char.height];
					_part_x_return = __grid[# i, __chitter_char.part_offset_x];
					_part_y_return = __grid[# i, __chitter_char.part_offset_y];
					_particles = __grid[# i, __chitter_char.part];

				}
		
				_ord = __grid[# i, __chitter_char.chord];
				
				if _ord == 0 { continue; }
										
				if __write_pos < __string_length and !__grid[# i, __chitter_char.typewriter] { 
					__write_pos = __string_length;
					__floor_pos = __string_length;
					__text_skip_typewriter();
				}
					
							
				if _particles {
					
					_part_id = __grid[# i, __chitter_char.part_id];
					_part_type = __part_id[| _part_id];
					_part_count = __grid[# i, __chitter_char.part_number];
					
					if _part_id == -1 and !part_type_exists(_part_type) or is_undefined(_part_type) { continue; }
					
					if _part_x_return != 0 {
						
						if _part_x_return > 0 {
							__grid[# i, __chitter_char.part_offset_x] = clamp(__grid[# i, __chitter_char.part_offset_x] - __grid[# i, __chitter_char.part_offset_x_return_speed], 0, _part_x_return);
						}			
					
						if _part_x_return < 0 {
							__grid[# i, __chitter_char.part_offset_x] = clamp(__grid[# i, __chitter_char.part_offset_x] + __grid[# i, __chitter_char.part_offset_x_return_speed], _part_x_return, 0);
						}	
						
					}
					
					if _part_y_return != 0 {
						
						if _part_y_return > 0 {
							__grid[# i, __chitter_char.part_offset_y] = clamp(__grid[# i, __chitter_char.part_offset_y] - __grid[# i, __chitter_char.part_offset_y_return_speed], 0, _part_y_return);
							_active++;
						}	
					
						if _part_y_return < 0 {
							__grid[# i, __chitter_char.part_offset_y] = clamp(__grid[# i, __chitter_char.part_offset_y] + __grid[# i, __chitter_char.part_offset_y_return_speed], _part_y_return, 0);
							_active++;
						}	
						
						_active++;
						
					}
					
					if __grid[# i, __chitter_char.part_fade_in] {
							
						var _value = __fade_in(i, "part", __chitter_struct, __grid);
																		
						_part_count *= _value;
					}

					if __grid[# i, __chitter_char.part_fade_out] {
							
						var _value = __fade_out(i, "part", __chitter_struct, __grid);
							
						if _value <= 0 { __grid[# i, __chitter_char.part] = false; }						
					}
						
					if __grid[# i, __chitter_char.part_colour_rainbow] {
						
						_hue = __grid[# i, __chitter_char.part_hue];
						
						__grid[# i, __chitter_char.part_hue] = (_hue + __grid[# i, __chitter_char.part_colour_rainbow_speed]) mod 255;
					
						var _set_colour1  = make_colour_hsv(_hue, 255, 255);
						var _set_colour2  = make_colour_hsv(_hue, 255, 255);
						
						part_type_colour_mix(_part_type, _set_colour1, _set_colour2);
						
					}
					
					if __grid[# i, __chitter_char.part_colour_random] == true {
						
						var _pred   = irandom(__grid[# i, __chitter_char.part_colour_random_red]);
						var _pgreen = irandom(__grid[# i, __chitter_char.part_colour_random_green]);
						var _pblue  = irandom(__grid[# i, __chitter_char.part_colour_random_blue]);
						var _pset_colour  = make_colour_rgb(_pred, _pgreen, _pblue);
						
						part_type_colour1(_part_type, _pset_colour);
						
					}
					
					if __grid[# i, __chitter_char.part_orientation_oscillate] {
										
						var _amp = __grid[# i, __chitter_char.part_orientation_oscillate_amp];
						
						_angle = __grid[# i, __chitter_char.part_orientation_oscillate_angle] * sin(_time / __grid[# i, __chitter_char.part_orientation_oscillate_frq] - i * __grid[# i, __chitter_char.part_orientation_oscillate_sep]) * _amp; 					
						
						part_type_orientation(_part_type, _angle, _angle, 0, 0, false);

					}

					if __grid[# i, __chitter_char.part_wave] {
					
						var _amp = __grid[# i, __chitter_char.part_wave_amp];
	
						if __grid[# i, __chitter_char.part_wave_fade_in] {

							_amp *= __fade_in(i, "part_wave", __chitter_struct, __grid);
							
						}
						
						if __grid[# i, __chitter_char.part_wave_fade_out] {
							
							var _value = __fade_out(i, "part_wave", __chitter_struct, __grid);
							
							if _value <= 0 { __grid[# i, __chitter_char.part_wave] = false; }
							
							_amp *= _value;
							
						}
					
					
						_xx += lengthdir_x(sin(_time / __grid[# i, __chitter_char.part_wave_frq] - i * __grid[# i, __chitter_char.part_wave_sep]) * _amp, __grid[# i, __chitter_char.part_wave_angle]);
						_yy += lengthdir_y(sin(_time / __grid[# i, __chitter_char.part_wave_frq] - i * __grid[# i, __chitter_char.part_wave_sep]) * _amp, __grid[# i, __chitter_char.part_wave_angle]);
						
					}
					
					if __grid[# i, __chitter_char.part_pulsate_x] {
					
						var _amp = __grid[# i, __chitter_char.part_pulsate_amp];
	
						if __grid[# i, __chitter_char.part_pulsate_fade_in] {

							_amp *= __fade_in(i, "part_pulsate", __chitter_struct, __grid);
							
						}
						
						if __grid[# i, __chitter_char.part_pulsate_fade_out] {
							
							var _value = __fade_out(i, "part_pulsate", __chitter_struct, __grid);
							
							if _value <= 0 { __grid[# i, __chitter_char.part_pulsate_x] = false; }
							
							_amp *= _value;
							
						}
					
						_scale_x += cos(_time / __grid[# i, __chitter_char.part_pulsate_frq] - i * __grid[# i, __chitter_char.part_pulsate_sep]) * _amp;
						

					}

					if __grid[# i, __chitter_char.part_pulsate_y] {	
					
						var _amp = __grid[# i, __chitter_char.part_pulsate_amp];
	
						if __grid[# i, __chitter_char.part_pulsate_fade_in] {

							_amp *= __fade_in(i, "part_pulsate", __chitter_struct, __grid);
							
						}
						
						if __grid[# i, __chitter_char.part_pulsate_fade_out] {
							
							var _value = __fade_out(i, "part_pulsate", __chitter_struct, __grid);
							
							if _value <= 0 { __grid[# i, __chitter_char.pulsate_x] = false; }
							
							_amp *= _value;
							
						}
					
						_scale_y += sin(_time / __grid[# i, __chitter_char.part_pulsate_frq] - i * __grid[# i, __chitter_char.part_pulsate_sep]) * _amp;

					}
				
					if __grid[# i, __chitter_char.part_pulsate_x] or __grid[# i, __chitter_char.part_pulsate_y] {
						part_type_scale(_part_type, _scale_x, _scale_y);
					}
					
					part_type_subimage(_part_type, _ord);
						
					part_particles_create(__part_system,
										  _x + _part_x_return + _xx,
										  _y + _part_y_return + _yy,
										  _part_type,
										  _part_count);				
					
					_active++;
					
				}
						
			}
			
			//Draw spawned particles
			part_system_drawit(__part_system);

			//Draw modified substring
			for (var i = 0; i < __string_pos; ++i) {
						
				var _modified = __grid[# i, __chitter_char.chmod];
			
				if _modified or __font_draw_each {
				
					_xx =		 __grid[# i, __chitter_char.width];
					_yy =		 __grid[# i, __chitter_char.height];
					_x_return =  __grid[# i, __chitter_char.offset_x];
					_y_return =	 __grid[# i, __chitter_char.offset_y];
					_scale_x =	 __grid[# i, __chitter_char.scale_x];
					_scale_y =	 __grid[# i, __chitter_char.scale_y];
					_angle	 =	 __grid[# i, __chitter_char.rotation_angle];
					_colour1 =	 __grid[# i, __chitter_char.colour1];
					_colour2 =	 __grid[# i, __chitter_char.colour2];
					_colour3 =	 __grid[# i, __chitter_char.colour3];
					_colour4 =	 __grid[# i, __chitter_char.colour4];
					_alpha	 =	 __grid[# i, __chitter_char.alpha];
					_particles = __grid[# i, __chitter_char.part];
				}
						
				if _modified {
				
					_ord = __grid[# i, __chitter_char.chord];
				
					if _ord == 0 { continue; }
										
					if __write_pos < __string_length and !__grid[# i, __chitter_char.typewriter] { 
						__write_pos = __string_length;
						__floor_pos = __string_length;
						__text_skip_typewriter();
					}
											
					if __grid[# i, __chitter_char.font] != __font {				
						_active++;
					}
					
					draw_set_font(__grid[# i, __chitter_char.font]);
					
					if _x_return != 0 {
					
						if _x_return > 0 {
							__grid[# i, __chitter_char.offset_x] = clamp(__grid[# i, __chitter_char.offset_x] - __grid[# i, __chitter_char.offset_x_return_speed], 0, _x_return);
							_active++;
						}			
					
						if _x_return < 0 {
							__grid[# i, __chitter_char.offset_x] = clamp(__grid[# i, __chitter_char.offset_x] + __grid[# i, __chitter_char.offset_x_return_speed], _x_return, 0);
							_active++;
						}	
					
					}
					
					if _y_return != 0 {
						
						if _y_return > 0 {
							__grid[# i, __chitter_char.offset_y] = clamp(__grid[# i, __chitter_char.offset_y] - __grid[# i, __chitter_char.offset_y_return_speed], 0, _y_return);
							_active++;
						}	
					
						if _y_return < 0 {
							__grid[# i, __chitter_char.offset_y] = clamp(__grid[# i, __chitter_char.offset_y] + __grid[# i, __chitter_char.offset_y_return_speed], _y_return, 0);
							_active++;
						}	
					
					}
					
					if __grid[# i, __chitter_char.sdf] {
						
						_sdf_params.thickness	= 0;
						_sdf_params.coreColour	= c_white;
						_sdf_params.coreAlpha	= 1;
						
						var _sdf_core_colour  = __grid[# i, __chitter_char.sdf_core_colour];
						
						if __grid[# i, __chitter_char.sdf_core_rainbow] {
							
							_hue = __grid[# i, __chitter_char.sdf_core_hue];
							
							__grid[# i, __chitter_char.sdf_core_hue] = (_hue + __grid[# i, __chitter_char.sdf_core_rainbow_speed]) mod 255;
							
							_sdf_core_colour  = make_colour_hsv(_hue, 255, 255);
						}
						
						if __grid[# i, __chitter_char.sdf_core_colour_random] {
							
							var _r = irandom(__grid[# i, __chitter_char.sdf_core_colour_random_red]);
							var _g = irandom(__grid[# i, __chitter_char.sdf_core_colour_random_green]);
							var _b = irandom(__grid[# i, __chitter_char.sdf_core_colour_random_blue]);
														
							_sdf_core_colour  = make_colour_rgb(_r, _g, _b);
						}
						
						_sdf_params.thickness			= __grid[# i, __chitter_char.sdf_thickness];
						_sdf_params.coreColour			= _sdf_core_colour;
						_sdf_params.coreAlpha			= __grid[# i, __chitter_char.sdf_core_alpha];
						
						if __grid[# i, __chitter_char.sdf_outline] {
							
							_sdf_params.outlineEnable		= true;
							_sdf_params.outlineDistance		= 0;
							_sdf_params.outlineColour		= 0;
							_sdf_params.outlineAlpha		= 1;
							
							var _sdf_outline_colour  = __grid[# i, __chitter_char.sdf_outline_colour];
							
							_sdf_params.outlineDistance		= __grid[# i, __chitter_char.sdf_outline_distance];
														
							if __grid[# i, __chitter_char.sdf_outline_rainbow] {
								_hue = __grid[# i, __chitter_char.sdf_outline_hue];
								__grid[# i, __chitter_char.sdf_outline_hue] = (_hue + __grid[# i, __chitter_char.sdf_outline_rainbow_speed]) mod 255;
								_sdf_outline_colour  = make_colour_hsv(_hue, 255, 255);
							}

							if __grid[# i, __chitter_char.sdf_outline_colour_random] {
							
								var _r = irandom(__grid[# i, __chitter_char.sdf_outline_colour_random_red]);
								var _g = irandom(__grid[# i, __chitter_char.sdf_outline_colour_random_green]);
								var _b = irandom(__grid[# i, __chitter_char.sdf_outline_colour_random_blue]);
														
								_sdf_outline_colour  = make_colour_rgb(_r, _g, _b);
							}
						
							_sdf_params.outlineColour		= _sdf_outline_colour;
							
							_sdf_params.outlineAlpha		= __grid[# i, __chitter_char.sdf_outline_alpha];
						}
						
						if __grid[# i, __chitter_char.sdf_glow] {

							_sdf_params.glowEnable			= true;
							_sdf_params.glowStart			= 0;
							_sdf_params.glowEnd				= 0;
							_sdf_params.glowColour			= 0;
							_sdf_params.glowAlpha			= 1;

							var _sdf_glow_colour  = __grid[# i, __chitter_char.sdf_glow_colour];
						
							if __grid[# i, __chitter_char.sdf_glow_rainbow] {
								_hue = __grid[# i, __chitter_char.sdf_glow_hue];
								__grid[# i, __chitter_char.sdf_glow_hue] = (_hue + __grid[# i, __chitter_char.sdf_glow_rainbow_speed]) mod 255;
								_sdf_glow_colour  = make_colour_hsv(_hue, 255, 255);
							}
							
							if __grid[# i, __chitter_char.sdf_glow_colour_random] {
							
								var _r = irandom(__grid[# i, __chitter_char.sdf_glow_colour_random_red]);
								var _g = irandom(__grid[# i, __chitter_char.sdf_glow_colour_random_green]);
								var _b = irandom(__grid[# i, __chitter_char.sdf_glow_colour_random_blue]);
														
								_sdf_glow_colour  = make_colour_rgb(_r, _g, _b);
							}
													
							_sdf_params.glowStart			= __grid[# i, __chitter_char.sdf_glow_start];
							_sdf_params.glowEnd				= __grid[# i, __chitter_char.sdf_glow_end];
							_sdf_params.glowColour			= _sdf_glow_colour;
							_sdf_params.glowAlpha			= __grid[# i, __chitter_char.sdf_glow_alpha];
						}	
						
						if __grid[# i, __chitter_char.sdf_shadow] {
							
							_sdf_params.dropShadowEnable	= true;
							_sdf_params.dropShadowSoftness	= 0;
							_sdf_params.dropShadowOffsetX	= 0;
							_sdf_params.dropShadowOffsetY	= 0;
							_sdf_params.dropShadowColour	= 0;
							_sdf_params.dropShadowAlpha		= 1;
							
							var _sdf_shadow_colour  = __grid[# i, __chitter_char.sdf_shadow_colour];
						
							if __grid[# i, __chitter_char.sdf_shadow_rainbow] {
								_hue = __grid[# i, __chitter_char.sdf_shadow_hue];
								__grid[# i, __chitter_char.sdf_shadow_hue] = (_hue + __grid[# i, __chitter_char.sdf_shadow_rainbow_speed]) mod 255;
								_sdf_shadow_colour  = make_colour_hsv(_hue, 255, 255);
							}

							if __grid[# i, __chitter_char.sdf_shadow_colour_random] {
							
								var _r = irandom(__grid[# i, __chitter_char.sdf_shadow_colour_random_red]);
								var _g = irandom(__grid[# i, __chitter_char.sdf_shadow_colour_random_green]);
								var _b = irandom(__grid[# i, __chitter_char.sdf_shadow_colour_random_blue]);
														
								_sdf_shadow_colour  = make_colour_rgb(_r, _g, _b);
							}
						
							_sdf_params.dropShadowSoftness	= __grid[# i, __chitter_char.sdf_shadow_softness];
							_sdf_params.dropShadowOffsetX	= __grid[# i, __chitter_char.sdf_shadow_offset_x];
							_sdf_params.dropShadowOffsetY	= __grid[# i, __chitter_char.sdf_shadow_offset_y];
							_sdf_params.dropShadowColour	= _sdf_shadow_colour;
							_sdf_params.dropShadowAlpha		= __grid[# i, __chitter_char.sdf_shadow_alpha];
						}
						
						font_enable_effects(__grid[# i, __chitter_char.font], true, _sdf_params);
				
						_active++;
					}
					
					if __grid[# i, __chitter_char.wave] {
					
						var _amp = __grid[# i, __chitter_char.wave_amp];
	
						if __grid[# i, __chitter_char.wave_fade_in] {

							_amp *= __fade_in(i, "wave", __chitter_struct, __grid);
							
						}
						
						if __grid[# i, __chitter_char.wave_fade_out] {
							
							var _value = __fade_out(i, "wave", __chitter_struct, __grid);
							
							if _value <= 0 { __grid[# i, __chitter_char.wave] = false; }
							
							_amp *= _value;
							
						}
					
						_xx += lengthdir_x(sin(_time / __grid[# i, __chitter_char.wave_frq] - i * __grid[# i, __chitter_char.wave_sep]) * _amp, __grid[# i, __chitter_char.wave_angle]);
						_yy += lengthdir_y(sin(_time / __grid[# i, __chitter_char.wave_frq] - i * __grid[# i, __chitter_char.wave_sep]) * _amp, __grid[# i, __chitter_char.wave_angle]);
						
						_active++;
					}
								
					if __grid[# i, __chitter_char.pulsate_x] {
					
						var _amp = __grid[# i, __chitter_char.pulsate_amp];
	
						if __grid[# i, __chitter_char.pulsate_fade_in] {

							_amp *= __fade_in(i, "pulsate", __chitter_struct, __grid);
							
						}
						
						if __grid[# i, __chitter_char.pulsate_fade_out] {
							
							var _value = __fade_out(i, "pulsate", __chitter_struct, __grid);
							
							if _value <= 0 { __grid[# i, __chitter_char.pulsate_x] = false; }
							
							_amp *= _value;
							
						}
					
						_scale_x += cos(_time / __grid[# i, __chitter_char.pulsate_frq] - i * __grid[# i, __chitter_char.pulsate_sep]) * _amp;
						
						_active++;
					}
				
					if __grid[# i, __chitter_char.pulsate_y] {	
					
						var _amp = __grid[# i, __chitter_char.pulsate_amp];
	
						if __grid[# i, __chitter_char.pulsate_fade_in] {

							_amp *= __fade_in(i, "pulsate", __chitter_struct, __grid);
							
						}
						
						if __grid[# i, __chitter_char.pulsate_fade_out] {
							
							var _value = __fade_out(i, "pulsate", __chitter_struct, __grid);
							
							if _value <= 0 { __grid[# i, __chitter_char.pulsate_x] = false; }
							
							_amp *= _value;
							
						}
					
						_scale_y += sin(_time / __grid[# i, __chitter_char.pulsate_frq] - i * __grid[# i, __chitter_char.pulsate_sep]) * _amp;
					
						_active++;
					}
				
					if __grid[# i, __chitter_char.rotation_oscillate] {
										
						var _amp = __grid[# i, __chitter_char.rotation_oscillate_amp];
	
						if __grid[# i, __chitter_char.rotation_oscillate_fade_in] {

							_amp *= __fade_in(i, "rotation_oscillate", __chitter_struct, __grid);
							
						}
						
						if __grid[# i, __chitter_char.rotation_oscillate_fade_out] {
							
							var _value = __fade_out(i, "rotation_oscillate", __chitter_struct, __grid);
							
							if _value <= 0 { __grid[# i, __chitter_char.rotation_oscillate] = false; }
							
							_amp *= _value;
							
						}
					
						_angle = __grid[# i, __chitter_char.rotation_oscillate_angle] * sin(_time / __grid[# i, __chitter_char.rotation_oscillate_frq] - i * __grid[# i, __chitter_char.rotation_oscillate_sep]) * _amp; 
						
						_active++;
					}
				
					if __grid[# i, __chitter_char.rotation] {
					
						var _speed = __grid[# i, __chitter_char.rotation_speed];
	
						if __grid[# i, __chitter_char.rotation_fade_in] {

							var _value = __fade_in(i, "rotation", __chitter_struct, __grid);
							
							_speed *= _value;
							_angle *= _value;
							
						}
						
						if __grid[# i, __chitter_char.rotation_fade_out] {

							var _value = __fade_out(i, "rotation", __chitter_struct, __grid);
							var _fade_frames = __grid[# i, __chitter_char.rotation_fade_frames];
							
							if _fade_frames <= 0 { 
								__grid[# i, __chitter_char.rotation] = false; 
								__grid[# i, __chitter_char.rotation_angle] = 0; 
								__grid[# i, __chitter_char.rotation_speed] = 0;
							}
							
							if _fade_frames > 0 {
								_angle = lerp(360 * _speed, 0, 1 - _fade_frames / __grid[# i, __chitter_char.rotation_fade_target] * _value);
								__grid[# i, __chitter_char.rotation_angle] = _angle;
							}
						}
						
						__grid[# i, __chitter_char.rotation_angle] += _speed;
						
						_angle += __grid[# i, __chitter_char.rotation_angle];
						
						_active++;
					}
					
					if __grid[# i, __chitter_char.shake_x] {
					
						var _amount = __grid[# i, __chitter_char.shake_amount];
	
						if __grid[# i, __chitter_char.shake_fade_in] {

							_amount *= __fade_in(i, "shake", __chitter_struct, __grid);
							
						}
						
						if __grid[# i, __chitter_char.shake_fade_out] {
							
							var _value = __fade_out(i, "shake", __chitter_struct, __grid);
							
							if _value <= 0 { __grid[# i, __chitter_char.shake_x] = false; }
							
							_amount *= _value;
							
						}
					
						_xx += random(_amount);
						
						_active++;
					}
				
					if __grid[# i, __chitter_char.shake_y] {
					
						var _amount = __grid[# i, __chitter_char.shake_amount];
	
						if __grid[# i, __chitter_char.shake_fade_in] {

							_amount *= __fade_in(i, "shake", __chitter_struct, __grid);
							
						}
						
						if __grid[# i, __chitter_char.shake_fade_out] {
							
							var _value = __fade_out(i, "shake", __chitter_struct, __grid);
							
							if _value <= 0 { __grid[# i, __chitter_char.shake_y] = false; }
							
							_amount *= _value;
							
						}
					
						_yy += random(_amount);
						_active++;
					}
				
					if __grid[# i, __chitter_char.rainbow] {
						
						_hue = __grid[# i, __chitter_char.hue1];

						__grid[# i, __chitter_char.hue1] = (_hue + __grid[# i, __chitter_char.rainbow_speed]) mod 255;
						
						if __grid[# i, __chitter_char.rainbow_fade_in] {
							
							var _value = __fade_in(i, "rainbow", __chitter_struct, __grid);
							
							if _value >= 1 { __grid[# i, __chitter_char.rainbow_fade_in] = false; }
							
							_hue = lerp(__font_colour_base_hue, _hue, _value);
							_sat = lerp(__font_colour_base_sat, 255, _value);
							_val = lerp(__font_colour_base_val, 255, _value);

							_active++;
						}
												
						if __grid[# i, __chitter_char.rainbow_fade_out] {
							
							var _value = __fade_out(i, "rainbow", __chitter_struct, __grid);
							
							if _value <= 0 { __grid[# i, __chitter_char.rainbow] = false; }
							
							_sat = lerp(255, __font_colour_base_sat, 1 - _value);
							_val = lerp(255, __font_colour_base_val, 1 - _value);
							
							_active++;
						}
						
						var _set_colour1  = make_colour_hsv(_hue, _sat, _val);
						//var _set_colour2  = make_colour_hsv(_hue, 255, 255);
					
						_colour1 = _set_colour1;
						_colour2 = _set_colour1;
						_colour3 = _set_colour1;
						_colour4 = _set_colour1;
					
						_active++;
					}

					if __grid[# i, __chitter_char.colour_random] {
										
						var _r = irandom(__grid[# i, __chitter_char.colour_random_red]);
						var _g = irandom(__grid[# i, __chitter_char.colour_random_green]);
						var _b = irandom(__grid[# i, __chitter_char.colour_random_blue]);

						if __grid[# i, __chitter_char.colour_random_fade_in] {
							
							var _value = __fade_in(i, "colour_random", __chitter_struct, __grid);
							
							if _value >= 1 { __grid[# i, __chitter_char.colour_random_fade_in] = false; }
							
							_r = lerp(__font_colour_base_red,   _r, _value);
							_g = lerp(__font_colour_base_green, _g, _value);
							_b = lerp(__font_colour_base_blue,  _b, _value);

							_active++;
						}
												
						if __grid[# i, __chitter_char.colour_random_fade_out] {
							
							var _value = __fade_out(i, "colour_random", __chitter_struct, __grid);
							
							if _value <= 0 { __grid[# i, __chitter_char.colour_random] = false; }
							
							_r = lerp(_r, __font_colour_base_red,   1 - _value);
							_g = lerp(_g, __font_colour_base_green, 1 - _value);
							_b = lerp(_b, __font_colour_base_blue,  1 - _value);
							
							_active++;
						}

						var _set_colour  = make_colour_rgb(_r, _g, _b);

						_colour1 = _set_colour;
						_colour2 = _set_colour;
						_colour3 = _set_colour;
						_colour4 = _set_colour;
					
						_active++;
					}
				
					if __grid[# i, __chitter_char.alpha_fade_in] {
										
						_alpha *= __fade_in(i, "alpha", __chitter_struct, __grid);

						_active++;
					}
				
					if __grid[# i, __chitter_char.alpha_fade_out] {
						
						var _value = __fade_out(i, "alpha", __chitter_struct, __grid);
							
						if _value <= 0 { __grid[# i, __chitter_char.shake_x] = false; }
							
						_alpha *= _value;

						_active++;
					}
				
					if __grid[# i, __chitter_char.alpha_wave] {
					
						var _amp = __grid[# i, __chitter_char.alpha_wave_amp];
	
						if __grid[# i, __chitter_char.alpha_wave_fade_in] {

							_amp *= __fade_in(i, "alpha_wave", __chitter_struct, __grid);
							
						}
						
						if __grid[# i, __chitter_char.alpha_wave_fade_out] {
							
							var _value = __fade_out(i, "alpha_wave", __chitter_struct, __grid);
							
							if _value <= 0 { __grid[# i, __chitter_char.alpha_wave] = false; }
							
							_amp *= _value;
							
						}
					
						_alpha += sin(_time / __grid[# i, __chitter_char.alpha_wave_frq] - i * __grid[# i, __chitter_char.alpha_wave_sep]) * _amp;
						_active++;
					}

					if __grid[# i, __chitter_char.alpha_random] {
					
						var _amount = __grid[# i, __chitter_char.alpha_random_amount];
	
						if __grid[# i, __chitter_char.alpha_random_fade_in] {

							_amount *= __fade_in(i, "alpha_random", __chitter_struct, __grid);
							
						}
						
						if __grid[# i, __chitter_char.alpha_random_fade_out] {
							
							var _value = __fade_out(i, "alpha_random", __chitter_struct, __grid);
							
							if _value <= 0 { __grid[# i, __chitter_char.alpha_random] = false; }
							
							_amount *= _value;
							
						}
					
						_alpha = random(_amount);
						_active++;
					}

					if __grid[# i, __chitter_char.alpha_random_range] {
					
						var _fade_in = __grid[# i, __chitter_char.alpha_random_fade_in];
						var _fade_out = __grid[# i, __chitter_char.alpha_random_fade_out];
						var _amount_low = __grid[# i, __chitter_char.alpha_random_range_min];
						var _amount_high = __grid[# i, __chitter_char.alpha_random_range_max];
	
						if __grid[# i, __chitter_char.alpha_random_range_fade_in] {
							
							var _value = __fade_in(i, "alpha_random_range", __chitter_struct, __grid);
							
							_amount_low  *= _value;
							_amount_high *= _value;
							
						}
						
						if __grid[# i, __chitter_char.alpha_random_range_fade_out] {
							
							var _value = __fade_out(i, "alpha_random_range", __chitter_struct, __grid);
							
							if _value <= 0 { __grid[# i, __chitter_char.alpha_random_range] = false; }
							
							_amount_low  *= _value;
							_amount_high *= _value;
							
						}				
					
						_alpha = random_range(_amount_low, _amount_high);
						_active++;
					}
					
					if _particles {
						_active++;	
					}
										
					//No mods and base values, deactivate mods and re-add characters to normal drawn string.
					if _active == 0 and _colour1 == __font_colour_base and _angle == 0 and _alpha == 1 {
						__grid[# i, __chitter_char.chmod] = false;
					
						if __font_draw_each == false {
					
							__string_draw = string_delete(__string_draw, i + 1, 1);
							__string_draw = string_insert(__grid[# i, __chitter_char.char], __string_draw, i + 1);
						}
					}
				
					//No mods and invisible, deactivate modding.
					if _active == 0 and _alpha <= 0 {
						__grid[# i, __chitter_char.chmod] = false;
					
						if __font_draw_each == false {
					
							__string_draw = string_delete(__string_draw, i + 1, 1);
							__string_draw = string_insert(chr(32), __string_draw, i + 1);
						}
					}
				
				}
			
				if !_modified and __font_draw_each and _alpha == 1 {
				
					draw_set_font(__font);
				
				}
			
				if (!_particles or __grid[# i, __chitter_char.part_draw_text]) and (_modified or __font_draw_each) {
				
					if __font_draw_each and _alpha == 1 {
				
						draw_set_font(__font);
				
					}				
				
					draw_text_transformed_colour(_x + _x_return + _xx, 
												 _y + _y_return + _yy - __font_height_base * 0.5, 
								                 __grid[# i, __chitter_char.char],
												 _scale_x,
								                 _scale_y,
								                 _angle,
								                 _colour1,
								                 _colour2,
								                 _colour3,
								                 _colour4,
								                 _alpha);
					 
					
							
					if __grid[# i, __chitter_char.sdf] {
						font_enable_effects(__font, false);
						__sdf_reset(_sdf_params);
					}
				}

			}
		
		}
		
		//Draw non modified string if not drawing each.
		if !__font_draw_each {
			draw_set_halign(fa_left);
			draw_set_valign(fa_bottom);
		
			draw_text_colour(_x, _y - __font_height_base + string_height(__string_draw), __string_draw, __font_colour_base, __font_colour_base, __font_colour_base, __font_colour_base, 1);
		}
		
	};
		
	/// @ignore
	static __text_skip_typewriter = function() {
		for (var i = __string_pos + 1; i <= __string_length; ++i) {
			var _char = __grid[# i - 1, __chitter_char.char];
			__string_draw = !__grid[# i - 1, __chitter_char.chmod] ? __string_draw + _char  : __string_draw + chr(32);
		}
			
		__string_pos = __string_length;
	}

	/// @ignore
	static __text_gridify = function(_grid, _talker, _sprite, _string) {
		
		draw_set_font(__font);
		draw_set_valign(fa_bottom);
		
		var _str_len        = string_length(_string);
		var _str_width      = 0;
		var _str_height     = 0;

		__reset_to_base(__chitter_base, __chitter_struct, _grid, _str_len);

		for (var i = 0; i <= _str_len; ++i; ) {
		    
			var _str_char = string_char_at(_string, i + 1);
		    var _str_wid = string_width(_str_char);
			
		    _grid[# i, __chitter_char.chord]						= ord(_str_char) - 32;
		    _grid[# i, __chitter_char.char]							= _str_char;
		    _grid[# i, __chitter_char.width]						= _str_width * __font_scale_base;
			_grid[# i, __chitter_char.height]						= 0;
			_grid[# i, __chitter_char.talker]						= _talker;
			_grid[# i, __chitter_char.talker_sprite]				= _sprite;
			
			_str_width += _str_wid;
		
		}
		
		__string_length = _str_len;
	};
		
    /// @ignore
	static __text_modify = function(_grid, _part, _list) {
		
		var _list_length = ds_list_size(_list);
		
		if _list_length = 0 { exit; }
		
		var _readjust_width = false;
		var _readjust_height = false;
		var _linebreaks = [];
		
		for (var i = 0; i < _list_length; ++i) {
    
		    var _arr_length = array_length(_list[| i].names);
    
		    for (var ii = 0; ii < _arr_length; ++ii) {
		        var _name = _list[| i].names[ii];
				
				var _index_start = _list[| i].start;
				var _index_end = _list[| i].finish - 1;
				
				var _part_id = -1;
				
		        for (var iii = _index_start; iii < _index_end; ++iii) {
					
		            var _index = struct_get(__chitter_struct, _name);
					
		            var _value = _list[| i].values[ii];				
					
					if _index == undefined or _value == "" { __err_mod(_name, _value); }
					
					if string_pos("rainbow", _name) != 0 {
						
						var _hue = 255;
						
						if _name == "rainbow_backward" and _value == true { 
							_hue = abs(255 - (10 * iii));
						} else {
							_hue -= (10 * iii) + 100;
						}
						
						var _end = string_ends_with(_name, "speed");
						
						if string_starts_with(_name, "rainbow") and !_end {
							_grid[# iii, __chitter_char.hue1] = _hue;
							_grid[# iii, __chitter_char.hue2] = _hue;
						}
						
						if string_starts_with(_name, "part")	and !_end {
							_grid[# iii, __chitter_char.part_hue] = _hue;
						}
						
						if string_starts_with(_name, "sdf")		and !_end {
							_grid[# iii, __chitter_char.sdf_core_hue]	 = _hue;
							_grid[# iii, __chitter_char.sdf_outline_hue] = _hue;
							_grid[# iii, __chitter_char.sdf_glow_hue]	 = _hue;
							_grid[# iii, __chitter_char.sdf_shadow_hue]  = _hue;
						}
					
					}
										
					if _name == "colour" {
						_grid[# iii, __chitter_char.colour1] = _value;
						_grid[# iii, __chitter_char.colour2] = _value;
						_grid[# iii, __chitter_char.colour3] = _value;
						_grid[# iii, __chitter_char.colour4] = _value;
					} else {
						_grid[# iii, _index] = _value;
					}
					
					if _grid[# iii, __chitter_char.font] != __font {
					
						draw_set_font(_grid[# iii, __chitter_char.font]);
						
						var _str_wid_new = string_width(_grid[# iii, __chitter_char.char]);
						
						_grid[# iii + 1, __chitter_char.width] = _grid[# iii, __chitter_char.width] + _str_wid_new * __font_scale_base;

						_readjust_width = true;
					}
					
					if _grid[# iii, __chitter_char.colour_merge] {
						var _colour_1 = _grid[# iii, __chitter_char.colour_merge_1];
						var _colour_2 = _grid[# iii, __chitter_char.colour_merge_2];
						var _merge_amount = _grid[# iii, __chitter_char.colour_merge_amount];
						
						var _merge_value  = (_merge_amount / (_index_end / 2)) * (iii - _index_start - _index_end);
						
						var _colour_merged = merge_colour(_colour_2, _colour_1, clamp(abs(_merge_value), 0, 1));
						
						_grid[# iii, __chitter_char.colour] = _colour_merged;
						_grid[# iii, __chitter_char.colour1] = _colour_merged;
						_grid[# iii, __chitter_char.colour2] = _colour_merged;
						_grid[# iii, __chitter_char.colour3] = _colour_merged;
						_grid[# iii, __chitter_char.colour4] = _colour_merged;
					}
										
					if _grid[# iii, __chitter_char.direction] {

						var _angle = _grid[# iii, __chitter_char.direction_angle] + (iii - _index_start) * _grid[# iii, __chitter_char.direction_curve_level];
						var _char, _char_width = 0;
						
						if iii > _index_start  {
							
							_char = _grid[# iii - 1, __chitter_char.char];
						
							_grid[# iii, __chitter_char.width] = _grid[# iii - 1, __chitter_char.width];
							_grid[# iii, __chitter_char.height] = _grid[# iii - 1, __chitter_char.height];
						
							_char_width = string_width(_char);
						}
						
						_grid[# iii, __chitter_char.width]  += lengthdir_x(_char_width, _angle);
						_grid[# iii, __chitter_char.height] += lengthdir_y(_char_width, _angle);
						_grid[# iii, __chitter_char.rotation_angle] = _angle;
						_grid[# iii, __chitter_char.part_orientation] = true;
						_grid[# iii, __chitter_char.part_orientation_min] = _angle;
						_grid[# iii, __chitter_char.part_orientation_max] = _angle;
						
						if iii == _index_end - 2 {
							_grid[# iii + 1, __chitter_char.width] = _grid[# iii, __chitter_char.width];
							_readjust_width = true;
						}
						
					}
																				
					if _grid[# iii, __chitter_char.part] == true {
						
						var _id = _grid[# iii, __chitter_char.part_id];
						
						if _id >= 0 and _part_id != _id {
						
							if is_undefined(_part[| _id]) or !part_type_exists(_part[| _id]) {
								_part[| _id] = part_type_create();
							}						
												
							var _font =  _grid[# iii, __chitter_char.font];
							var _font_name = font_get_name(_font);
							__font_name = _font_name;					
						
							part_type_sprite(_part[| _id], 
												__font_sprite,
												false,
												false,
												false);
						
							part_type_colour1(_part[| _id], __font_colour_base);
							
						
							
							if _grid[# iii, __chitter_char.part_sprite] == true {
						
								part_type_sprite(_part[| _id], 
												 _grid[# iii, __chitter_char.part_sprite_image],
												 _grid[# iii, __chitter_char.part_sprite_animate],
												 _grid[# iii, __chitter_char.part_sprite_stretch],
												 _grid[# iii, __chitter_char.part_sprite_random]);
						
							}
						
							if _grid[# iii, __chitter_char.part_direction] == true {
							
								part_type_direction(_part[| _id], 
												 _grid[# iii, __chitter_char.part_direction_min],
												 _grid[# iii, __chitter_char.part_direction_max],
												 _grid[# iii, __chitter_char.part_direction_increase],
												 _grid[# iii, __chitter_char.part_direction_wiggle]);
							}
						
							if _grid[# iii, __chitter_char.part_speed] == true {
								part_type_speed(_part[| _id], 
												 _grid[# iii, __chitter_char.part_speed_min],
												 _grid[# iii, __chitter_char.part_speed_max],
												 _grid[# iii, __chitter_char.part_speed_incr],
												 _grid[# iii, __chitter_char.part_speed_wiggle]);
							}
						
							if _grid[# iii, __chitter_char.part_scale] == true {
								part_type_scale(_part[| _id], 
												 _grid[# iii, __chitter_char.part_scale_x],
												 _grid[# iii, __chitter_char.part_scale_y]);
							}
						
							if _grid[# iii, __chitter_char.part_life] == true {
								part_type_life(_part[| _id], 
											   _grid[# iii, __chitter_char.part_life_min],
											   _grid[# iii, __chitter_char.part_life_max]);								
							}
						
							if _grid[# iii, __chitter_char.part_colour1] != -1 {
								part_type_colour1(_part[| _id], _grid[# iii, __chitter_char.part_colour1]);								
							}
						
							if _grid[# iii, __chitter_char.part_colour2] == true {
								part_type_colour2(_part[| _id], 
												  _grid[# iii, __chitter_char.part_colour2_1],							
												  _grid[# iii, __chitter_char.part_colour2_2]);								
							}
						
							if _grid[# iii, __chitter_char.part_colour3] == true {
								part_type_colour3(_part[| _id], 
												  _grid[# iii, __chitter_char.part_colour3_1],							
												  _grid[# iii, __chitter_char.part_colour3_2],								
												  _grid[# iii, __chitter_char.part_colour3_3]);								
							}
						
							if _grid[# iii, __chitter_char.part_colour_mix] == true {
								part_type_colour_mix(_part[| _id], 
													 _grid[# iii, __chitter_char.part_colour_mix_1],							
													 _grid[# iii, __chitter_char.part_colour_mix_2]);
							}
												
							if _grid[# iii, __chitter_char.part_colour_hsv] == true {
								part_type_colour_hsv(_part[| _id], 
													 _grid[# iii, __chitter_char.part_colour_hsv_h_min],
													 _grid[# iii, __chitter_char.part_colour_hsv_h_max],
													 _grid[# iii, __chitter_char.part_colour_hsv_s_min],
													 _grid[# iii, __chitter_char.part_colour_hsv_s_max],
													 _grid[# iii, __chitter_char.part_colour_hsv_v_min],		
													 _grid[# iii, __chitter_char.part_colour_hsv_v_max]);
							}
												
							if _grid[# iii, __chitter_char.part_colour_rgb] == true {
								part_type_colour_rgb(_part[| _id], 
													 _grid[# iii, __chitter_char.part_colour_rgb_r_min],
													 _grid[# iii, __chitter_char.part_colour_rgb_r_max],
													 _grid[# iii, __chitter_char.part_colour_rgb_g_min],
													 _grid[# iii, __chitter_char.part_colour_rgb_g_max],
													 _grid[# iii, __chitter_char.part_colour_rgb_b_min],		
													 _grid[# iii, __chitter_char.part_colour_rgb_b_max]);
							}
						
							if _grid[# iii, __chitter_char.part_alpha1] != -1 {
								part_type_alpha1(_part[| _id], _grid[# iii, __chitter_char.part_alpha1]);								
							}
						
							if _grid[# iii, __chitter_char.part_alpha2] == true {
								part_type_alpha2(_part[| _id], 
												 _grid[# iii, __chitter_char.part_alpha2_1],							
												 _grid[# iii, __chitter_char.part_alpha2_2]);								
							}
						
							if _grid[# iii, __chitter_char.part_alpha3] == true {
								part_type_alpha3(_part[| _id], 
												 _grid[# iii, __chitter_char.part_alpha3_1],							
												 _grid[# iii, __chitter_char.part_alpha3_2],								
												 _grid[# iii, __chitter_char.part_alpha3_3]);								
							}
						
							if _grid[# iii, __chitter_char.part_gravity] == true {
								part_type_gravity(_part[| _id], 
												  _grid[# iii, __chitter_char.part_gravity_amount],							
												  _grid[# iii, __chitter_char.part_gravity_direction]);								
							}
						
							if _grid[# iii, __chitter_char.part_blend] != -1 {
								part_type_blend(_part[| _id], _grid[# iii, __chitter_char.part_blend]);
							}
				
							if _grid[# iii, __chitter_char.part_orientation] == true {
								part_type_orientation(_part[| _id], 
													  _grid[# iii, __chitter_char.part_orientation_min],
													  _grid[# iii, __chitter_char.part_orientation_max],
													  _grid[# iii, __chitter_char.part_orientation_incr],
													  _grid[# iii, __chitter_char.part_orientation_wiggle],
													  _grid[# iii, __chitter_char.part_orientation_relative]);
							}
				
							if _grid[# iii, __chitter_char.part_size] == true {
								part_type_size(_part[| _id], 
											   _grid[# iii, __chitter_char.part_size_min],
											   _grid[# iii, __chitter_char.part_size_max],
											   _grid[# iii, __chitter_char.part_size_incr],
											   _grid[# iii, __chitter_char.part_size_wiggle]);
							}
				
							if _grid[# iii, __chitter_char.part_size_x] == true {
								part_type_size_x(_part[| _id], 
												 _grid[# iii, __chitter_char.part_size_x_min],
												 _grid[# iii, __chitter_char.part_size_x_max],
												 _grid[# iii, __chitter_char.part_size_x_incr],
												 _grid[# iii, __chitter_char.part_size_x_wiggle]);
							}
				
							if _grid[# iii, __chitter_char.part_size_y] == true {
								part_type_size_y(__p_partart_id[| _id], 
												 _grid[# iii, __chitter_char.part_size_y_min],
												 _grid[# iii, __chitter_char.part_size_y_max],
												 _grid[# iii, __chitter_char.part_size_y_incr],
												 _grid[# iii, __chitter_char.part_size_y_wiggle]);
							}
						
							_part_id = _id;
						 
						}
						
					}
	
					if _grid[# iii, __chitter_char.line_break] and !_readjust_height {
						_readjust_height = true;
					} else {
						_grid[# iii, __chitter_char.chmod] = true;
					}
				
				}
				
				if _readjust_width {
					var _i = _index_end;
					if _i >= __string_length { continue; }
					
					draw_set_font(_grid[# _i, __chitter_char.font]);
					
					_grid[# iii, __chitter_char.width] = _grid[# iii, __chitter_char.width] + string_width(_grid[# iii, __chitter_char.char]);
					
					for (var iiii = _list[| i].finish; iiii <= __string_length; ++iiii) {
						var _str_wid_new = string_width(_grid[# iiii, __chitter_char.char]);
						_grid[# iiii, __chitter_char.width] = _grid[# iiii - 1, __chitter_char.width] + _str_wid_new * __font_scale_base;
						
					}
					
					_readjust_width = false;
				}
				
				if _readjust_height {
					
					draw_set_font(_grid[# iii, __chitter_char.font]);
					
					var _str_hgt_new = string_height(_grid[# iii, __chitter_char.char]);
					
					for (var iii = _list[| i].start; iii <= __string_length; ++iii) {
						
						_grid[# iii, __chitter_char.height] = _grid[# iii, __chitter_char.height] + _str_hgt_new * __font_scale_base;
						
					}
					
					var _width_new = _grid[# _list[| i].start, __chitter_char.char] != chr(32) ? 0 : -string_width(chr(32));
					
					_grid[# _list[| i].start, __chitter_char.width] = _width_new;
					
					for (var iii = _list[| i].start; iii <= __string_length; ++iii) {
						
						var _str_wid_new = string_width(_grid[# iii, __chitter_char.char]);
						_grid[# iii, __chitter_char.width] = _width_new;
						_width_new += _str_wid_new * __font_scale_base;

					}
					_readjust_height = false;
					
				}
		    }
		}
				
	}
	
    /// @ignore
	static __text_parse = function(_string) {

		var _string_new = _string;
		
		var _i = 0;
		repeat(__chitter_premod_count) {
			var _premod = __chitter_premod_names[_i];
			repeat (string_count(_premod, _string_new)) {
				if string_pos(_premod, _string_new) != 0 {
					_string_new = string_replace(_string_new, _premod, __chitter_premod[$ _premod]);
				}
			}
			_i++;
		}

		var _modifier_list = ds_list_create();
		var _string_length = string_length(_string_new);
		var _modifier_get = "";
		var _modifier_length = 0;
		var _value_identifier = false;

		for (var i = 1; i < _string_length; ++i) {
    
		    var _identifier = string_char_at(_string_new, i);
			
			if ord(_identifier) == 10 {

				_string_new = string_replace(_string_new, chr(10), "[line_break] []");
				_identifier = string_char_at(_string_new, i);
				_string_length = string_length(_string_new);
			
			}
		    
			if _identifier == "[" {
        
		        var _ds_length = ds_list_size(_modifier_list);
        
		        ds_list_add(_modifier_list, {
		            start : i - 1,
		            modifier : [""],
		            value : [""]
		        });
        
		        for (var ii = i; ii < _string_length; ++ii) {
            
		            _identifier = string_char_at(_string_new, ii + 1);
					            
		            if _identifier == chr(32) { 
		                continue;
		            }
            
		            if _identifier == "]" {
		                _modifier_list[| _ds_length].finish = ii;
		                _modifier_list[| _ds_length].length = ii + 2 - i ;
		                _value_identifier = false;
		                break;
		            }
            
		            if _identifier == "," { 
		                _value_identifier = false;
		                _modifier_length++;
		                array_set(_modifier_list[| _ds_length].modifier, _modifier_length, "");
		                array_set(_modifier_list[| _ds_length].value, _modifier_length, "");
		                continue;
		            }
            
		            if _identifier == ":" { 
		                _value_identifier = true; 
		                continue; 
		            }
            
		            if _value_identifier == false {
                
		                _modifier_list[| _ds_length].modifier[_modifier_length] += _identifier;
		                continue;
		            }
            
		            _modifier_list[| _ds_length].value[_modifier_length] += _identifier;
		        }
		        _modifier_length = 0;
		    }
		}
				
		__string_current = _string_new;
		return _modifier_list;
	}
	
    /// @ignore
	static __text_parse_second = function(_string) {

		var _string_new = _string;
		
		var _modifier_list = ds_list_create();
		var _string_length = string_length(_string_new);
		var _modifier_get = "";
		var _modifier_length = 0;
		var _value_identifier = false;

		for (var i = 1; i < _string_length; ++i) {
    
		    var _identifier = string_char_at(_string_new, i);
					    
			if _identifier == "[" {
        
		        var _ds_length = ds_list_size(_modifier_list);
        
		        ds_list_add(_modifier_list, {
		            start : i - 1,
		            modifier : [""],
		            value : [""]
		        });
        
		        for (var ii = i; ii < _string_length; ++ii) {
            
		            _identifier = string_char_at(_string_new, ii + 1);
					            
		            if _identifier == chr(32) { 
		                continue;
		            }
            
		            if _identifier == "]" {
		                _modifier_list[| _ds_length].finish = ii;
		                _modifier_list[| _ds_length].length = ii + 2 - i ;
		                _value_identifier = false;
		                break;
		            }
            
		            if _identifier == "," { 
		                _value_identifier = false;
		                _modifier_length++;
		                array_set(_modifier_list[| _ds_length].modifier, _modifier_length, "");
		                array_set(_modifier_list[| _ds_length].value, _modifier_length, "");
		                continue;
		            }
            
		            if _identifier == ":" { 
		                _value_identifier = true; 
		                continue; 
		            }
            
		            if _value_identifier == false {
                
		                _modifier_list[| _ds_length].modifier[_modifier_length] += _identifier;
		                continue;
		            }
            
		            _modifier_list[| _ds_length].value[_modifier_length] += _identifier;
		        }
		        _modifier_length = 0;
		    }
		}
				
		return _modifier_list;
	}
	
}
