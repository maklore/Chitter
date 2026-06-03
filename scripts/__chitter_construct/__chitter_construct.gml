//Feather ignore all
function __chitter() constructor {
		
	__game_speed = game_get_speed(gamespeed_fps);
	__grid_size = 1_000;
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
	
	//for writer, not sure if it will be used.
	__string_write = "";
	
	static __chitter_struct = new __chitter_enum_struct();
	static __chitter_premod = new __chitter_premods();
	static __chitter_base	= undefined;
	
	__chitter_struct_names  = struct_get_names(__chitter_struct);
	__chitter_struct_count  = struct_names_count(__chitter_struct);
	__chitter_premod_names  = struct_get_names(__chitter_premod);
	__chitter_premod_count  = struct_names_count(__chitter_premod);
	__chitter_base_names    = undefined;
	__chitter_base_count    = undefined;
	
		
	//Sort premod array by string length in descending order
	array_sort(__chitter_premod_names, function(_current, _next) {
			return string_length(_next) - string_length(_current);
	});

	/**
	Makes the system draw ready.
	Currently only compatible with monospace font.
	@param {ASSET.GMFont} _fontASSET Base font to be drawn.
	@param {Constant.colour or Real} _fontColour Base colour to be drawn.
	@param {ASSET.GMSound} _sound Plays set sound per drawn character.
	@param {Bool} _fontDrawEach Set true if using a non monospace font.
	*/
	static initialise = function(_fontASSET, _fontColour, _soundASSET = undefined, _fontDrawEach = false) {
		
		__font = _fontASSET;
		__font_name = font_get_name(_fontASSET);
		__font_draw_each = _fontDrawEach;
		__font_colour_base = _fontColour;
		__font_colour_base_red   = colour_get_red(__font_colour_base);
		__font_colour_base_green = colour_get_green(__font_colour_base);
		__font_colour_base_blue  = colour_get_blue(__font_colour_base);
		__font_colour_base_hue   = colour_get_hue(__font_colour_base);
		__font_colour_base_sat   = colour_get_saturation(__font_colour_base);
		__font_colour_base_val   = colour_get_value(__font_colour_base);
		
		draw_set_font(_fontASSET);
		__font_width_base = string_width("|");
		__font_height_base = string_height("|");
				
		//Get all font assets.
		var _font_ids = asset_get_ids(asset_font);
		var _font_count = array_length(_font_ids);
		var _i = 0;
		
		//For each font asset create a sprite for each letter.
		repeat _font_count {
			var _id = _font_ids[_i];
			
			var _name = font_get_name(_id);
			__font_sprite_struct[$ _name] = __font_to_spr(_id, 33, 128);
			
			_i++;
		}
		
		//Set primary font and sound.
		__font_sprite = __font_sprite_struct[$ __font_name];		
		__sound = _soundASSET;
		
		__chitter_base = new __chitter_base_struct(self);
		__chitter_base_names   = struct_get_names(__chitter_base);
		__chitter_base_count   = struct_names_count(__chitter_base);

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
		var __mod_list   = __text_list_clean(_text_list);
		
		var _list_size   = ds_list_size(_queue.__string_list);
		var _clean_list = __text_parse_second(_string);
		var _clean_text = __text_clean(_string, _clean_list);
		
		ds_list_add(_queue.__grid, ds_grid_create(__grid_size, __chitter_char.length));
		ds_list_add(_queue.__part_id, ds_list_create());
				
		__text_gridify(_queue.__grid[| _list_size], _name, _sprite, _clean_text);
		__text_modify(_queue.__grid[| _list_size], _queue.__part_id[| _list_size], __mod_list);

		ds_list_add(_queue.__string_list, _clean_text);
			
		__string_length = 0;
		
		return self;
	}
	
	/**
	Sends the modified string from the queue to be drawn.
	*
	@param {string} _id Queue ID.
	*/
	static next = function(_id) {
		
		static _id_prev = _id;
		
		if !struct_exists(__chitter_queue, _id) {
			show_debug_message($"Invalid ID : {_id}");
			return -2;
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
		__write_pos = 0;
		__string_pos = 0;
		__floor_pos = 0;
		__string_draw = "";	
		
		//Fetch oldest data from queue.
		__string_length = string_length(__queue.__string_list[| 0]);
		__string_current = __queue.__string_list[| 0];
			
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
			show_debug_message($"Invalid ID : {_id}");
			exit;
		}
		var __queue = __chitter_queue[$ _id];

		return (ds_list_size(__queue.__string_list) == 0);

	}

	/**
	Returns the current active talker.
	*/
	static talker = function() {
		if !__next { return undefined; }
		return __grid[# __floor_pos, __chitter_char.talker];
	}
	
	/**
	Returns the current active sprite.
	*/
	static sprite = function() {
		if !__next { return undefined; }
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

		static _ord = 0, 
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

		if __next == false { exit; }
		
		if __write_pos <= __string_length + 1 {
			
			__floor_pos = floor(__write_pos);
			
			__write_pos += __grid[# __floor_pos, __chitter_char.write_speed];
			
			if __string_pos < __floor_pos {
				
				var _char = string_char_at(__string_current, __floor_pos);
				
				//If the char position is modified replace string with a space (only works for monospace font...)
				__string_draw = !__grid[# __string_pos, __chitter_char.chmod] ? __string_draw + _char : __string_draw + chr(32);
				
				__string_pos++;
				
				if __sound != undefined and _char != chr(10) and _char != chr(13) { 
					var _index		= __grid[# __string_pos, __chitter_char.sound_index];
					var _priority	= __grid[# __string_pos, __chitter_char.sound_priority];
					var _loops		= __grid[# __string_pos, __chitter_char.sound_loop];
					var _gain		= __grid[# __string_pos, __chitter_char.sound_gain_random]   ? random_range(__grid[# __string_pos, __chitter_char.sound_gain_low],   __grid[# __string_pos, __chitter_char.sound_gain_high])   : __grid[# __string_pos, __chitter_char.sound_gain];
					var _offset		= __grid[# __string_pos, __chitter_char.sound_offset_random] ? random_range(__grid[# __string_pos, __chitter_char.sound_offset_low], __grid[# __string_pos, __chitter_char.sound_offset_high]) : __grid[# __string_pos, __chitter_char.sound_offset];
					var _pitch		= __grid[# __string_pos, __chitter_char.sound_pitch_random]  ? random_range(__grid[# __string_pos, __chitter_char.sound_pitch_low],  __grid[# __string_pos, __chitter_char.sound_pitch_high])  : __grid[# __string_pos, __chitter_char.sound_pitch];
					var _mask		= __grid[# __string_pos, __chitter_char.sound_listener_mask];
					if _index != -1 {
						audio_play_sound(_index, _priority, _loops, _gain, _offset, _pitch);
					}
				}
			}
			
		}
		
		draw_set_font(__font);
		
		if __font_draw_each == false {
			draw_set_halign(fa_left);
			draw_set_valign(fa_bottom);
		
			//Draw non modified string
			draw_text_colour(_x, _y - __font_height_base + string_height(__string_draw), __string_draw, __font_colour_base, __font_colour_base, __font_colour_base, __font_colour_base, 1);
		}

		draw_set_halign(fa_left);
		draw_set_valign(fa_middle);
		
		var _time = current_time * (pi * 2);

		//Draw modified substring
		for (var i = 0; i < __string_pos; ++i) {
			
			var _active = 0;
			
			if __grid[# i, __chitter_char.chmod] or __font_draw_each {
				_xx =		 __grid[# i, __chitter_char.width];
				_yy =		 __grid[# i, __chitter_char.height];
				_scale_x =	 __grid[# i, __chitter_char.scale_x];
				_scale_y =	 __grid[# i, __chitter_char.scale_y];
				_angle	 =	 __grid[# i, __chitter_char.rotation_angle];
				_colour1 =	 __grid[# i, __chitter_char.colour1];
				_colour2 =	 __grid[# i, __chitter_char.colour2];
				_colour3 =	 __grid[# i, __chitter_char.colour3];
				_colour4 =	 __grid[# i, __chitter_char.colour4];
				_alpha	 =	 __grid[# i, __chitter_char.alpha];
			}
						
			//Only draw/create particle if position is modified.
			if __grid[# i, __chitter_char.chmod] {
				
				_ord = __grid[# i, __chitter_char.chord];
				
				if _ord == 0 { continue; }
										
				if __write_pos < __string_length and !__grid[# i, __chitter_char.typewriter] { 
					__write_pos = __string_length;
					__floor_pos = __string_length;
					__text_skip_typewriter();
				}
							
				_xx =		 __grid[# i, __chitter_char.width];
				_yy =		 __grid[# i, __chitter_char.height];
				_particles = __grid[# i, __chitter_char.particles];
							
				if _particles {
					
					_part_id = __grid[# i, __chitter_char.part_id];
					_part_type = __part_id[| _part_id];
					_part_count = __grid[# i, __chitter_char.part_number];
					
					if _part_id == -1 and !part_type_exists(_part_type) or is_undefined(_part_type) { continue; }
					///CHECK add part fade/hard stop
					
					if __grid[# i, __chitter_char.part_fade_out] {
							
						var _value = __fade_out(i, "part", __chitter_struct, __grid);
							
						if _value <= 0 { __grid[# i, __chitter_char.particles] = false; }
							
					}
					
					if __grid[# i, __chitter_char.part_colour_rainbow] {
						
						_hue = __grid[# i, __chitter_char.part_hue];
						
						__grid[# i, __chitter_char.part_hue] = (_hue + __grid[# i, __chitter_char.part_colour_rainbow_speed]) mod 255;
					
						var _set_colour1  = make_colour_hsv(_hue, 255, 255);
						var _set_colour2  = make_colour_hsv(_hue, 255, 255);
						
						part_type_colour_mix(_part_type, _set_colour1, _set_colour2);
						
						_active++;
					}
					
					if __grid[# i, __chitter_char.part_colour_random] == true {
						
						var _pred   = irandom(__grid[# i, __chitter_char.part_colour_random_red]);
						var _pgreen = irandom(__grid[# i, __chitter_char.part_colour_random_green]);
						var _pblue  = irandom(__grid[# i, __chitter_char.part_colour_random_blue]);
						var _pset_colour  = make_colour_rgb(_pred, _pgreen, _pblue);
						
						part_type_colour1(_part_type, _pset_colour);
						
						_active++;
					}

					if __grid[# i, __chitter_char.part_wave_x] {
					
						var _amp = __grid[# i, __chitter_char.part_wave_amp];
	
						if __grid[# i, __chitter_char.part_wave_fade_in] {

							_amp *= __fade_in(i, "part_wave", __chitter_struct, __grid);
							
						}
						
						if __grid[# i, __chitter_char.part_wave_fade_out] {
							
							var _value = __fade_out(i, "part_wave", __chitter_struct, __grid);
							
							if _value <= 0 { __grid[# i, __chitter_char.part_wave_x] = false; }
							
							_amp *= _value;
							
						}
					
						_xx += cos(_time / __grid[# i, __chitter_char.part_wave_frq] - i * __grid[# i, __chitter_char.part_wave_sep]) * _amp;
						
						_active++;
					}
				
					if __grid[# i, __chitter_char.part_wave_y] {
					
						var _amp = __grid[# i, __chitter_char.part_wave_amp];
	
						if __grid[# i, __chitter_char.part_wave_fade_in] {

							_amp *= __fade_in(i, "part_wave", __chitter_struct, __grid);
							
						}
						
						if __grid[# i, __chitter_char.part_wave_fade_out] {
							
							var _value = __fade_out(i, "part_wave", __chitter_struct, __grid);
							
							if _value <= 0 { __grid[# i, __chitter_char.part_wave_y] = false; }
							
							_amp *= _value;
							
						}
					
						_yy += sin(_time / __grid[# i, __chitter_char.part_wave_frq] - i * __grid[# i, __chitter_char.part_wave_sep]) * _amp;
						
						_active++;
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
						
						_active++;
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

						_active++;
					}
				
					if __grid[# i, __chitter_char.part_pulsate_x] or __grid[# i, __chitter_char.part_pulsate_y] {
						part_type_scale(_part_type, _scale_x, _scale_y);
					}
					
					part_type_subimage(_part_type, _ord);
						
					part_particles_create(__part_system,
											_x + _xx,
											_y + _yy,
											_part_type,
											_part_count);				
					
					_active++;
					
				}

				if __grid[# i, __chitter_char.part_draw_text] == true or !_particles {
										
					if __grid[# i, __chitter_char.font] != __font {				
						_active++;
					}
					
					draw_set_font(__grid[# i, __chitter_char.font]);
					
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
					
					if __grid[# i, __chitter_char.wave_x] {
					
						var _amp = __grid[# i, __chitter_char.wave_amp];
	
						if __grid[# i, __chitter_char.wave_fade_in] {

							_amp *= __fade_in(i, "wave", __chitter_struct, __grid);
							
						}
						
						if __grid[# i, __chitter_char.wave_fade_out] {
							
							var _value = __fade_out(i, "wave", __chitter_struct, __grid);
							
							if _value <= 0 { __grid[# i, __chitter_char.wave_x] = false; }
							
							_amp *= _value;
							
						}
					
						_xx += cos(_time / __grid[# i, __chitter_char.wave_frq] - i * __grid[# i, __chitter_char.wave_sep]) * _amp;
						
						_active++;
					}
				
					if __grid[# i, __chitter_char.wave_y] {
					
						var _amp = __grid[# i, __chitter_char.wave_amp];
	
						if __grid[# i, __chitter_char.wave_fade_in] {

							_amp *= __fade_in(i, "wave", __chitter_struct, __grid);
							
						}
						
						if __grid[# i, __chitter_char.wave_fade_out] {
							
							var _value = __fade_out(i, "wave", __chitter_struct, __grid);
							
							if _value <= 0 { __grid[# i, __chitter_char.wave_y] = false; }
							
							_amp *= _value;
							
						}
					
						_yy += sin(_time / __grid[# i, __chitter_char.wave_frq] - i * __grid[# i, __chitter_char.wave_sep]) * _amp;
						
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
					
					draw_text_transformed_colour(_x + _xx, 
							                     _y + _yy - __font_height_base * 0.5, 
							                     __grid[# i, __chitter_char.char],
												 _scale_x,
							                     _scale_y,
							                     _angle,
							                     _colour1,
							                     _colour2,
							                     _colour3,
							                     _colour4,
							                     _alpha);
					 
					font_enable_effects(__font, false);
							
					if __grid[# i, __chitter_char.sdf] {
						__sdf_reset(_sdf_params);
					}
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
				
			} else if __font_draw_each == true and _alpha == 1 {
				
				draw_set_font(__font);
								
				draw_text_transformed_colour(_x + _xx, 
											 _y + _yy - __font_height_base * 0.5, 
											 __grid[# i, __chitter_char.char],
											 _scale_x,
											 _scale_y,
											 _angle,
											 _colour1,
											 _colour2,
											 _colour3,
											 _colour4,
											 _alpha);	
			}
		
		
		}
		
		//Draw particles
		part_system_drawit(__part_system);

	};
	
	/**
	Returns the active string width's and height's as an array.
	*
	text_size[0] Width as being drawn.
	text_size[1] Height as being drawn.
	text_size[2] Total width.
	text_size[3] Total height.
	*/
	static text_border = function() {
		if string_length(__string_draw) < 1 { return [0, 0, 0, 0]; }
		return [string_width(__string_draw), string_height(__string_draw), string_width(__string_current), string_height(__string_current)];	
	}
	
	/// @ignore
	static __text_skip_typewriter = function() {
		for (var i = __string_pos + 1; i <= __string_length; ++i) {
			var _char = string_char_at(__string_current, i);
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

		__reset_to_base(_grid, _str_len + 1);

		for (var i = 0; i <= _str_len; ++i; ) {
		    
			var _str_char = string_char_at(_string, i + 1);
		    var _str_wid = string_width(_str_char);

		    _grid[# i, __chitter_char.chord]						= ord(_str_char) - 32;
		    _grid[# i, __chitter_char.char]							= _str_char;
		    _grid[# i, __chitter_char.width]						= _str_width * __font_scale_base;
			_grid[# i, __chitter_char.height]						= 0;
			
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

					if _index = undefined { show_debug_message($"Invalid modifier tag: {_name}") continue; }
					
		            var _value = _list[| i].values[ii];				
					
					if string_pos("rainbow", _name) != 0 {
						
						var _hue = 255;
						
						if _name == "rainbow_backward" and _value == true { 
							_hue = abs(255 - (10 * iii));
						} else {
							_hue -= (10 * iii) + 100;
						}
						
						if string_starts_with(_name, "rainbow") and !string_ends_with(_name, "speed") {
							_grid[# iii, __chitter_char.hue1] = _hue;
							_grid[# iii, __chitter_char.hue2] = _hue;
						}
						if string_starts_with(_name, "part") and !string_ends_with(_name, "speed") {
							_grid[# iii, __chitter_char.part_hue] = _hue;
						}
						if string_starts_with(_name, "sdf") and !string_ends_with(_name, "speed") {
							_grid[# iii, __chitter_char.sdf_core_hue] = _hue;
							_grid[# iii, __chitter_char.sdf_outline_hue] = _hue;
							_grid[# iii, __chitter_char.sdf_glow_hue] = _hue;
							_grid[# iii, __chitter_char.sdf_shadow_hue] = _hue;
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
						
						var _colour_merged = merge_colour(_colour_1, _colour_2, clamp((_merge_amount / (_index_end / 2)) * (iii - _index_start), 0, 1)) ;
						
						_grid[# iii, __chitter_char.colour] = _colour_merged;
						_grid[# iii, __chitter_char.colour1] = _colour_merged;
						_grid[# iii, __chitter_char.colour2] = _colour_merged;
						_grid[# iii, __chitter_char.colour3] = _colour_merged;
						_grid[# iii, __chitter_char.colour4] = _colour_merged;
					}
					
					if !_readjust_height and _grid[# iii, __chitter_char.line_break] {
						array_push(_linebreaks, iii);
						_readjust_height = true;
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
															
					if !_readjust_height {
						_grid[# iii, __chitter_char.chmod] = true;
					}
					
					if _grid[# iii, __chitter_char.particles] == true {
						
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

		var _linebreak_len = array_length(_linebreaks);
		
		if _linebreak_len > 0 {
			var _i = _linebreak_len - 1;
			repeat _linebreak_len {
				var _pos = _linebreaks[_i];
				
				__string_current = string_insert("\n", __string_current, _pos + 1);
				__string_current = string_delete(__string_current, _pos + 2, 1);
				
				_i--;
			}
		}
		
		__string_length = string_length(__string_current);
		

	}
	
    /// @ignore
	static __text_list_clean = function(_list) {
		
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
				if _name == "sound_index" or 
				   _name == "talker_sprite" or 
				   _name == "part_sprite_image" or
				   _name == "font" {
					_values[ii] = asset_get_index(_values[ii]);

					continue;
				}
				
				if _values[ii] == "true" {
					var _true = true;
					_values[ii] = _true;
					continue;
				}

				if _values[ii] == "false" {
					var _false = false;
					_values[ii] = _false;
					continue;
				}

		        if array_contains(_colours, _name) {
					if string_starts_with(_values[ii], "#") or string_letters(_values[ii]) != "" {
						var _hex = __hex_to_colour(_values[ii]);
						_values[ii] = _hex;
					} else {
						var _real = _values[ii];
						_values[ii] = real(_real);
					}
		        } else {
		            var _real = _values[ii];
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
				//_string_new = string_replace(_string_new, chr(13), "");
				_string_new = string_replace(_string_new, chr(10), "[line_break : true] []");
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
				
		__string_current = _string_new;
		return _modifier_list;
	}
	
    /// @ignore
	static __text_clean = function(_string, _list) {
		var _string_new = _string;
		var _ds_length = ds_list_size(_list);
		
		for (var i = _ds_length - 1; i >= 0; --i;) {
			_string_new = string_delete(_string_new, _list[| i].start + 1, _list[| i].length);
		}
		return _string_new;
	}
	
	/// @ignore 
	static __reset_to_base = function(_grid, _size) {
			
		for (var g = 0; g < _size; ++g) {
			for (var i = 0; i < __chitter_base_count; ++i) {
				var _name		= __chitter_base_names[i];
			    var _index		= __chitter_struct[$ _name];
				var _base		= __chitter_base[$ _name];
				var _current	= _grid[# g, _index];

				if _current != _base {
					_grid[# g, _index] = _base;
				}
			}
		}
	}
	
    /// @ignore
	static __hex_to_colour = function(_string) {

	    static _struct_hex = {
	        "0" : 0,
	        "1" : 1,
	        "2" : 2,
	        "3" : 3,
	        "4" : 4,
	        "5" : 5,
	        "6" : 6,
	        "7" : 7,
	        "8" : 8,
	        "9" : 9,
	        "A" : 10,
	        "B" : 11,
	        "C" : 12,
	        "D" : 13,
	        "E" : 14,
	        "F" : 15
	    }
		
	    static _ddig = 16;
	    static _base = 256;
	    static _max_r = _base;
	    static _max_g = _max_r * _base;
	    static _max_b = _max_g * _base;
		
		var _string_upper = string_upper(string_delete(_string, 1, 1));

	    var _R1 = _max_r / _base * struct_get(_struct_hex, string_char_at(_string_upper, 2));
	    var _R2 = _max_r / _ddig * struct_get(_struct_hex, string_char_at(_string_upper, 1));
	    var _G1 = _max_g / _base * struct_get(_struct_hex, string_char_at(_string_upper, 4));
	    var _G2 = _max_g / _ddig * struct_get(_struct_hex, string_char_at(_string_upper, 3));
	    var _B1 = _max_b / _base * struct_get(_struct_hex, string_char_at(_string_upper, 6));
	    var _B2 = _max_b / _ddig * struct_get(_struct_hex, string_char_at(_string_upper, 5));

	    return (_R1 + _R2 + _G1 + _G2 + _B1 + _B2);
	}
		
	/// @ignore
	static __font_to_spr = function(_font, _range_min, _range_max) { 

		draw_set_halign(fa_left);	
	    draw_set_valign(fa_bottom);
		
	    draw_set_font(_font);
	    
		var _size = font_get_size(_font) * 2;
	    var _ind = _range_min;
	    var _len = _range_max - _range_min;
	    var _surf_wh = _size;
	    var _draw_w = 0;
	    var _draw_h = _size;
	    var _spr_return = undefined;
	    var _surf = surface_create(_surf_wh, _surf_wh);
    
	    if surface_exists(_surf) {
	        _spr_return = sprite_create_from_surface(_surf, 0, 0, _size, _size, true, false, _draw_w, _draw_h); 
	        surface_set_target(_surf);
	        repeat (_len) {
	            draw_clear_alpha(c_black, 0);
	            draw_text(_draw_w, _draw_h, chr(_ind));
	            sprite_add_from_surface(_spr_return, _surf, 0, 0, _size, _size, false, false);
	            _ind++;
	        }
	        surface_reset_target();
	        surface_free(_surf);
	    }
		
	    return _spr_return;
	}
}
