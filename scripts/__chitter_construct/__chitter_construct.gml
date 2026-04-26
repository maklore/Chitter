//Made with help from blovarsk, and germ3x

//Feather ignore all
function __chitter() constructor {
	
	__grid = ds_grid_create(1000, __chitter_char.length);
	ds_grid_set_region(__grid, 0, 0, 1000, __chitter_char.length, undefined);
    
	__queue = ds_list_create();
	__sprite = ds_list_create();
	__talker = ds_list_create();
	__part_id = ds_list_create();
	
	__part_system = part_system_create();
	part_system_draw_order(__part_system, true);
	part_system_automatic_draw(__part_system, false);
	
	__font = undefined;
	__font_sprite = undefined;
	__font_scale = 1;
	__font_sprite_struct = {};
	__font_name = undefined;
	__break_width = 2000;
	__sound = undefined;
	__write_pos = 0;
	__floor_pos = 0;
	__next = false;
	__string_current = "";
	__string_length = 0;
	
	static __chitter_struct = global.__chitter_struct;
	static __chitter_premod = new __chitter_premods();
	__chitter_premod_names = struct_get_names(__chitter_premod);
	__chitter_premod_count = struct_names_count(__chitter_premod);

	/**
	Makes the system draw ready.
	@param {ASSET.GMFont} _font Font to draw string.
	@param {real} _break_width Optional, default is undefined. Width in pixels to begin a new line.
	@param {ASSET.GMSound} _sound Optional, default is undefined. Sound to play for each letter drawn.
	*/
	static initialise = function(_font, _break_width = undefined, _sound = undefined) {
		__font = _font;
		__font_name = font_get_name(_font);
		
		var _font_ids = asset_get_ids(asset_font);
		var _font_count = array_length(_font_ids);
		var _i = 0;
		repeat _font_count {
			var _id = _font_ids[_i];
			
			var _name = font_get_name(_id);
			__font_sprite_struct[$ _name] = __font_to_spr(_id, 33, 128)
			_i++
		}
		
		__font_sprite = __font_sprite_struct[$ __font_name];
		__break_width = _break_width;
		__sound = _sound;
	}
		
	/**
	Add name, sprite, and the modified string of the talker to a queue system. An example of modified string: 
	*
	*"Hello [wave_y : true, color : #ff0000]world![]"
	*
	Empty brackets [] are required to know when to stop modifying.
	This will draw the string "world!" in red, and moving up and down like a wave.
	*
	See Documentation for a list of available modifiers.
	*
	@param {string} _talker Name of the talker.
	@param {ASSET.GMSprite} _sprite Sprite of the talker.
	@param {string} _string String or modified string of the talker.
	*/
	static add = function(_talker, _sprite, _string) {
		
		ds_list_add(__queue, _string);
		ds_list_add(__talker, _talker);
		ds_list_add(__sprite, _sprite);
		
		return self;
	}
	
	/**
	Gets the next talker in the queue, arranges and ships the data to draw. If there are no more talkers in the queue it returns false.
	*/
	static next = function() {
				
		if __write_pos >= __string_length and ds_list_size(__queue) == 0 {
			
			__next = false;
			return __next; 
		}
		
		if __write_pos < __string_length {
			__write_pos = __string_length - 1;

			__next = true;
			return __next;
		}
		
		__next = true;

		var _part_list_size = ds_list_size(__part_id);
		var _i = 0;
		
		repeat __part_id {
			if part_type_exists(__part_id[| _i]) {
				part_type_destroy(__part_id[| _i]);
			}
			_i++
			
		}
		
		__write_pos = 0;
		
		var _string = ds_list_find_value(__queue, 0);
		var _talker = ds_list_find_value(__talker, 0);
		var _sprite = ds_list_find_value(__sprite, 0);
		
		var _text_list = __text_parse(_string);
		var _text_cleansed = __text_clean(__string_current, _text_list);

		_text_list = __text_list_clean(_text_list);
		
		__string_length = string_length(_text_cleansed);

		__text_gridify(_talker, _sprite, _text_cleansed, __break_width);
		
		__text_modify(_text_list, __grid);
			
		ds_list_delete(__queue, 0);
		ds_list_delete(__talker, 0);
		ds_list_delete(__sprite, 0);
				
		return __next;
		
	};
	
	/**
	Returns the current active talker.
	*/
	static talker = function() {
		if !__next { return undefined }
		return __grid[# __floor_pos, __chitter_char.talker];
	}
	
	/**
	Returns the current active sprite.
	*/
	static sprite = function() {
		if !__next { return undefined }
		return __grid[# __floor_pos, __chitter_char.talker_sprite];
	}
	
	/**
	Plays the initialised and/or modified sound using the 
	changable values. If not initialised it will not play anything unless set with string modification.
	*/
	static sound = function() {
		if !__next { exit }
		static _current_pos = 1;
		if __sound == undefined and __grid[# __floor_pos, __chitter_char.sound] == false { exit; }
		if _current_pos != __floor_pos { 
			_current_pos	= __floor_pos;
			var _index		= __grid[# __floor_pos, __chitter_char.sound_index];
			var _priority	= __grid[# __floor_pos, __chitter_char.sound_priority];
			var _loops		= __grid[# __floor_pos, __chitter_char.sound_loop];
			var _gain		= __grid[# __floor_pos, __chitter_char.sound_gain_random]   ? random_range(__grid[# __floor_pos, __chitter_char.sound_gain_low],   __grid[# __floor_pos, __chitter_char.sound_gain_high])	: __grid[# __floor_pos, __chitter_char.sound_gain];
			var _offset		= __grid[# __floor_pos, __chitter_char.sound_offset_random] ? random_range(__grid[# __floor_pos, __chitter_char.sound_offset_low], __grid[# __floor_pos, __chitter_char.sound_offset_high]) : __grid[# __floor_pos, __chitter_char.sound_offset];
			var _pitch		= __grid[# __floor_pos, __chitter_char.sound_pitch_random]  ? random_range(__grid[# __floor_pos, __chitter_char.sound_pitch_low],  __grid[# __floor_pos, __chitter_char.sound_pitch_high])	: __grid[# __floor_pos, __chitter_char.sound_pitch];
			var _mask		= __grid[# __floor_pos, __chitter_char.sound_listener_mask];
		
			audio_play_sound(_index, _priority, _loops, _gain, _offset, _pitch);
		}
	};
	
	/**
	Clears the queue.
	*/
	static cleanup = function() {
		ds_list_clear(__queue);
		ds_list_clear(__talker);
		ds_list_clear(__sprite);
		var _part_list_size = ds_list_size(__part_id);
		var _i = 0;
		repeat __part_id {
			if part_type_exists(__part_id[| _i]) {
				part_type_destroy(__part_id[| _i]);
			}
			_i++
		}
		
		ds_list_clear(__part_id);
		
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
	@param {real} _x The x position to draw the modified string.
	@param {real} _y The y position to draw the modified string.
	*/
	static draw = function(_x, _y) {

		if __next == false { exit; }
		
		
		if __write_pos < __string_length {
			__floor_pos = floor(__write_pos);
			__write_pos += __grid[# __floor_pos, __chitter_char.write_speed];	
		}
		
		var _time = current_time * (pi * 2);
		
		for (var i = 0; i <= __floor_pos; ++i) {
			
			if __write_pos < __string_length and !__grid[# i, __chitter_char.typewriter] { 
				__write_pos = __string_length - 1
				__floor_pos = __string_length - 1
			}
			
			var _font = __grid[# i, __chitter_char.font];
			
			if draw_get_font() != _font {  
				draw_set_font(_font);
			}

			if __grid[# i, __chitter_char.chmod] {
								
			    if __grid[# i, __chitter_char.wave_x] {
					__grid[# i, __chitter_char.wave_xx] = cos(_time / __grid[# i, __chitter_char.wave_frq] - i * __grid[# i, __chitter_char.wave_sep]) * __grid[# i, __chitter_char.wave_amp]; 
				}
				
			    if __grid[# i, __chitter_char.wave_y] {
					__grid[# i, __chitter_char.wave_yy] = sin(_time / __grid[# i, __chitter_char.wave_frq] - i * __grid[# i, __chitter_char.wave_sep]) * __grid[# i, __chitter_char.wave_amp]; 
				}
				
			    if __grid[# i, __chitter_char.pulsate_x] {
					__grid[# i, __chitter_char.pulsate_xx] = cos(_time / __grid[# i, __chitter_char.pulsate_frq] - i * __grid[# i, __chitter_char.pulsate_sep]) * __grid[# i, __chitter_char.pulsate_amp]; 
				}
				
			    if __grid[# i, __chitter_char.pulsate_y] {
					__grid[# i, __chitter_char.pulsate_yy] = sin(_time / __grid[# i, __chitter_char.pulsate_frq] - i * __grid[# i, __chitter_char.pulsate_sep]) * __grid[# i, __chitter_char.pulsate_amp]; 
				}
				
			    if __grid[# i, __chitter_char.rotation_oscillate] {
					__grid[# i, __chitter_char.rotation_angle] = __grid[# i, __chitter_char.rotation_oscillate_angle] * sin(_time / __grid[# i, __chitter_char.rotation_oscillate_frq] - i * __grid[# i, __chitter_char.rotation_oscillate_sep]) * __grid[# i, __chitter_char.rotation_oscillate_amp]; 
				}
				
			    if __grid[# i, __chitter_char.rotation] {
					__grid[# i, __chitter_char.rotation_angle] -= __grid[# i, __chitter_char.rotation_speed]; 
				}

			    if __grid[# i, __chitter_char.shake_x] {
					__grid[# i, __chitter_char.shake_xx] = random(__grid[# i, __chitter_char.shake_amount]); 
				}
				
			    if __grid[# i, __chitter_char.shake_y] {
					__grid[# i, __chitter_char.shake_yy] = random(__grid[# i, __chitter_char.shake_amount]); 
				}
				
			    if __grid[# i, __chitter_char.rainbow] {
					__grid[# i, __chitter_char.hue1] = (__grid[# i, __chitter_char.hue1] + __grid[# i, __chitter_char.rainbow_speed]) mod 255;
					__grid[# i, __chitter_char.hue2] = (__grid[# i, __chitter_char.hue1] + __grid[# i, __chitter_char.rainbow_speed]) mod 255;
					var _set_color1  = make_colour_hsv(__grid[# i, __chitter_char.hue1], 255, 255);
					var _set_color2  = make_colour_hsv(__grid[# i, __chitter_char.hue2], 255, 255);
					__grid[# i, __chitter_char.color1] = _set_color1;
					__grid[# i, __chitter_char.color2] = _set_color2;
					__grid[# i, __chitter_char.color3] = _set_color2;
					__grid[# i, __chitter_char.color4] = _set_color1;
					
				}
				
			    if __grid[# i, __chitter_char.disco] {
					var _red   = irandom(__grid[# i, __chitter_char.disco_red]);
					var _green = irandom(__grid[# i, __chitter_char.disco_green]);
					var _blue  = irandom(__grid[# i, __chitter_char.disco_blue]);
					var _set_color  = make_colour_rgb(_red, _green, _blue);
					__grid[# i, __chitter_char.color1] = _set_color;
					__grid[# i, __chitter_char.color2] = _set_color;
					__grid[# i, __chitter_char.color3] = _set_color;
					__grid[# i, __chitter_char.color4] = _set_color;
					
				}

				if __grid[# i, __chitter_char.particles] {

					var _id = __grid[# i, __chitter_char.part_id];
					
					if part_type_exists(__part_id[| _id]) {
												
						part_system_drawit(__part_system);
						

						if __grid[# i, __chitter_char.rainbow] {
							part_type_colour_mix(__part_id[| _id], __grid[# i, __chitter_char.color1], __grid[# i, __chitter_char.color2]);
							
						}
						
						if __grid[# i, __chitter_char.disco] {
							var _red   = irandom(__grid[# i, __chitter_char.disco_red]);
							var _green = irandom(__grid[# i, __chitter_char.disco_green]);
							var _blue  = irandom(__grid[# i, __chitter_char.disco_blue]);
							part_type_colour_rgb(__part_id[| _id], _red, _red, _green, _green, _blue, _blue);	
						}
						
						part_type_subimage(__part_id[| _id], __grid[# i, __chitter_char.chord]);
						
						part_particles_create(__part_system,
											  _x + __grid[# i, __chitter_char.width]  + __grid[# i, __chitter_char.wave_xx] + __grid[# i, __chitter_char.shake_xx],
											  _y + __grid[# i, __chitter_char.height] + __grid[# i, __chitter_char.wave_yy] + __grid[# i, __chitter_char.shake_yy],
											  __part_id[| _id],
											  __grid[# i, __chitter_char.part_number]);
											  
											  

					}
				}				
			}
    

				
			if __grid[# i, __chitter_char.draw_text] == false and __grid[# i, __chitter_char.particles] == false {
					
				var _sprite = __font_sprite_struct[$ font_get_name(_font)];
					
				draw_sprite_ext(_sprite, 
								__grid[# i, __chitter_char.chord], 
				                _x + __grid[# i, __chitter_char.width]  + __grid[# i, __chitter_char.wave_xx] + __grid[# i, __chitter_char.shake_xx], 
				                _y + __grid[# i, __chitter_char.height] + __grid[# i, __chitter_char.wave_yy] + __grid[# i, __chitter_char.shake_yy] + __grid[# i, __chitter_char.direction_y], 
				                __grid[# i, __chitter_char.scale] * __grid[# i, __chitter_char.scale_x] + __grid[# i, __chitter_char.pulsate_xx], 
				                __grid[# i, __chitter_char.scale] * __grid[# i, __chitter_char.scale_y] + __grid[# i, __chitter_char.pulsate_yy], 
				                __grid[# i, __chitter_char.rotation_angle], 
				                __grid[# i, __chitter_char.color1], 
				                __grid[# i, __chitter_char.alpha]);
			}
				
			

			//if __grid[# i, __chitter_char.draw_text] == true and __grid[# i, __chitter_char.particles] == false {
			//	draw_text_transformed_colour(_x + __grid[# i, __chitter_char.width]  + __grid[# i, __chitter_char.wave_xx] + __grid[# i, __chitter_char.shake_xx], 
			//			                     _y + __grid[# i, __chitter_char.height] + __grid[# i, __chitter_char.wave_yy] + __grid[# i, __chitter_char.shake_yy], 
			//			                     __grid[# i, __chitter_char.char],
			//								 __grid[# i, __chitter_char.scale] * __grid[# i, __chitter_char.scale_x] + __grid[# i, __chitter_char.pulsate_xx], 
			//			                     __grid[# i, __chitter_char.scale] * __grid[# i, __chitter_char.scale_y] + __grid[# i, __chitter_char.pulsate_yy], 
			//			                     __grid[# i, __chitter_char.rotation_angle], 
			//			                     __grid[# i, __chitter_char.color1], 
			//			                     __grid[# i, __chitter_char.color2], 
			//			                     __grid[# i, __chitter_char.color3], 
			//			                     __grid[# i, __chitter_char.color4], 
			//			                     __grid[# i, __chitter_char.alpha]);
			//}
		}
	};
	
    /// @ignore
	static __text_gridify = function(_talker, _sprite, _string, _breakwidth) {
		
		draw_set_font(__font)
		
		var _str_len        = string_length(_string);
		var _str_width      = 0;
		var _str_height     = 0;
		var _str_breakline  = 0;

		for (var i = 0; i <= _str_len; ++i; ) {
		    
			var _str_char = string_char_at(_string, i + 1);
		    var _str_wid = string_width(_str_char);
			
			#region Reset to base
		    __grid[# i, __chitter_char.chord]							= ord(_str_char) - 32;
		    __grid[# i, __chitter_char.char]							= _str_char;
		    __grid[# i, __chitter_char.chmod]							= false;
		    __grid[# i, __chitter_char.font]							= __font;
		    __grid[# i, __chitter_char.line_break]						= false;
		    __grid[# i, __chitter_char.draw_text]						= false;
			__grid[# i, __chitter_char.scale]							= __font_scale;
			__grid[# i, __chitter_char.scale_x]							= 1;
			__grid[# i, __chitter_char.scale_y]							= 1;
		    __grid[# i, __chitter_char.width]							= _str_width * __font_scale;
		    __grid[# i, __chitter_char.height]							= _str_height * 1.5 * __font_scale;
		    __grid[# i, __chitter_char.color]							= c_white;
		    __grid[# i, __chitter_char.color1]							= c_white;
		    __grid[# i, __chitter_char.color2]							= c_white;
		    __grid[# i, __chitter_char.color3]							= c_white;
		    __grid[# i, __chitter_char.color4]							= c_white;
			__grid[# i, __chitter_char.wave_x]							= false;
			__grid[# i, __chitter_char.wave_xx]							= 0;
			__grid[# i, __chitter_char.wave_y]							= false;
			__grid[# i, __chitter_char.wave_yy]							= 0;
			__grid[# i, __chitter_char.wave_frq]						= 800;
			__grid[# i, __chitter_char.wave_amp]						= 5;
			__grid[# i, __chitter_char.wave_sep]						= 1;
			__grid[# i, __chitter_char.wave_ez_in]						= -1;		//Not in use
			__grid[# i, __chitter_char.wave_ez_out]						= -1;		//Not in use
			__grid[# i, __chitter_char.wave_ez_spd]						= 0;		//Not in use
			__grid[# i, __chitter_char.pulsate_x]						= false;
			__grid[# i, __chitter_char.pulsate_xx]						= 0;
			__grid[# i, __chitter_char.pulsate_y]						= false;
			__grid[# i, __chitter_char.pulsate_yy]						= 0;
			__grid[# i, __chitter_char.pulsate_frq]						= 800;
			__grid[# i, __chitter_char.pulsate_amp]						= 0.05;
			__grid[# i, __chitter_char.pulsate_sep]						= 1;
			__grid[# i, __chitter_char.pulsate_ez_in]					= 1;		//Not in use
			__grid[# i, __chitter_char.pulsate_ez_out]					= 1;		//Not in use
			__grid[# i, __chitter_char.pulsate_ez_spd]					= 1;		//Not in use
			__grid[# i, __chitter_char.shake_x]							= false;
			__grid[# i, __chitter_char.shake_xx]						= false;
			__grid[# i, __chitter_char.shake_y]							= false;
			__grid[# i, __chitter_char.shake_yy]						= false;
			__grid[# i, __chitter_char.shake_amount]					= 1;
			__grid[# i, __chitter_char.shake_ez_in]						= 1;		//Not in use
			__grid[# i, __chitter_char.shake_ez_out]					= 1;		//Not in use
			__grid[# i, __chitter_char.shake_ez_spd]					= 1;		//Not in use
			__grid[# i, __chitter_char.rotation]						= false;
			__grid[# i, __chitter_char.rotation_angle]					= 0;
			__grid[# i, __chitter_char.rotation_speed]					= 0;
			__grid[# i, __chitter_char.rotation_oscillate]				= false;
			__grid[# i, __chitter_char.rotation_oscillate_angle]		= 0;
			__grid[# i, __chitter_char.rotation_oscillate_frq]			= 800;
			__grid[# i, __chitter_char.rotation_oscillate_amp]			= 5;
			__grid[# i, __chitter_char.rotation_oscillate_sep]			= 1;
			__grid[# i, __chitter_char.direction]						= false;
			__grid[# i, __chitter_char.direction_x]						= 0;
			__grid[# i, __chitter_char.direction_y]						= 0;
			__grid[# i, __chitter_char.direction_angle]					= 0;
			__grid[# i, __chitter_char.direction_curve_level]					= false;
			__grid[# i, __chitter_char.disco]							= false;
			__grid[# i, __chitter_char.disco_red]						= 255;
			__grid[# i, __chitter_char.disco_green]						= 255;
			__grid[# i, __chitter_char.disco_blue]						= 255;
			__grid[# i, __chitter_char.typewriter]						= true;
			__grid[# i, __chitter_char.write_speed]						= 0.2;
			__grid[# i, __chitter_char.hue1]							= 0;
			__grid[# i, __chitter_char.hue2]							= 0;
			__grid[# i, __chitter_char.rainbow]							= false;
			__grid[# i, __chitter_char.rainbow_speed]					= 1;
			__grid[# i, __chitter_char.alpha]							= 1;
			__grid[# i, __chitter_char.talker]							= _talker;
			__grid[# i, __chitter_char.talker_sprite]					= _sprite;
			__grid[# i, __chitter_char.sound]							= false;
			__grid[# i, __chitter_char.sound_index]						= __sound;
			__grid[# i, __chitter_char.sound_priority]					= 0;
			__grid[# i, __chitter_char.sound_loop]						= false;
			__grid[# i, __chitter_char.sound_gain]						= 1;
			__grid[# i, __chitter_char.sound_gain_low]					= 0.8;
			__grid[# i, __chitter_char.sound_gain_high]					= 1;
			__grid[# i, __chitter_char.sound_gain_random]				= true;
			__grid[# i, __chitter_char.sound_offset]					= 0;
			__grid[# i, __chitter_char.sound_offset_low]				= 0;
			__grid[# i, __chitter_char.sound_offset_high]				= 1;
			__grid[# i, __chitter_char.sound_offset_random]				= false;
			__grid[# i, __chitter_char.sound_pitch]						= 1;
			__grid[# i, __chitter_char.sound_pitch_low]					= 0.9;
			__grid[# i, __chitter_char.sound_pitch_high]				= 1.1;
			__grid[# i, __chitter_char.sound_pitch_random]				= true;
			//__grid[# i, __chitter_char.sound_listener_mask]				= __sound != undefined ? audio_sound_get_listener_mask(__sound) : 0;
			__grid[# i, __chitter_char.particles]						= false;
			__grid[# i, __chitter_char.part_id]					= -1;
			__grid[# i, __chitter_char.part_number]				= 1;
			__grid[# i, __chitter_char.part_sprite]				= false;
			__grid[# i, __chitter_char.part_sprite_image]			= __font_sprite_struct[$ font_get_name(__font)];
			__grid[# i, __chitter_char.part_sprite_animate]		= false;
			__grid[# i, __chitter_char.part_sprite_stretch]		= false;
			__grid[# i, __chitter_char.part_sprite_random]			= false;
			__grid[# i, __chitter_char.part_size]					= false;
			__grid[# i, __chitter_char.part_size_min]				= 0;
			__grid[# i, __chitter_char.part_size_max]				= 0;
			__grid[# i, __chitter_char.part_size_incr]				= 0;
			__grid[# i, __chitter_char.part_size_wiggle]			= false;
			__grid[# i, __chitter_char.part_size_x]				= false;
			__grid[# i, __chitter_char.part_size_x_min]			= 0;
			__grid[# i, __chitter_char.part_size_x_max]			= 0;
			__grid[# i, __chitter_char.part_size_x_incr]			= 0;
			__grid[# i, __chitter_char.part_size_x_wiggle]			= false;
			__grid[# i, __chitter_char.part_size_y]				= false;
			__grid[# i, __chitter_char.part_size_y_min]			= 0;
			__grid[# i, __chitter_char.part_size_y_max]			= 0;
			__grid[# i, __chitter_char.part_size_y_incr]			= 0;
			__grid[# i, __chitter_char.part_size_y_wiggle]			= false;
			__grid[# i, __chitter_char.part_scale]					= true;
			__grid[# i, __chitter_char.part_scale_x]				= __font_scale;
			__grid[# i, __chitter_char.part_scale_y]				= __font_scale;
			__grid[# i, __chitter_char.part_speed]					= false;
			__grid[# i, __chitter_char.part_speed_min]				= 0;
			__grid[# i, __chitter_char.part_speed_max]				= 0;
			__grid[# i, __chitter_char.part_speed_incr]			= 0;
			__grid[# i, __chitter_char.part_speed_wiggle]			= false;
			__grid[# i, __chitter_char.part_direction]				= false;
			__grid[# i, __chitter_char.part_direction_min]			= 0;
			__grid[# i, __chitter_char.part_direction_max]			= 0;
			__grid[# i, __chitter_char.part_direction_incr]		= 0;
			__grid[# i, __chitter_char.part_direction_wiggle]		= false;
			__grid[# i, __chitter_char.part_gravity]				= false;
			__grid[# i, __chitter_char.part_gravity_amount]		= 0;
			__grid[# i, __chitter_char.part_gravity_direction]		= false;
			__grid[# i, __chitter_char.part_orientation]			= false;
			__grid[# i, __chitter_char.part_orientation_min]		= 0;
			__grid[# i, __chitter_char.part_orientation_max]		= 0;
			__grid[# i, __chitter_char.part_orientation_incr]		= 0;
			__grid[# i, __chitter_char.part_orientation_wiggle]	= false;
			__grid[# i, __chitter_char.part_orientation_relative]	= false;
			__grid[# i, __chitter_char.part_colour_mix]			= false;
			__grid[# i, __chitter_char.part_colour_mix_1]			= 0;
			__grid[# i, __chitter_char.part_colour_mix_2]			= 0;
			__grid[# i, __chitter_char.part_colour_rgb]			= false;
			__grid[# i, __chitter_char.part_colour_rgb_r_min]		= 0;
			__grid[# i, __chitter_char.part_colour_rgb_r_max]		= 255;
			__grid[# i, __chitter_char.part_colour_rgb_g_min]		= 0;
			__grid[# i, __chitter_char.part_colour_rgb_g_max]		= 255;
			__grid[# i, __chitter_char.part_colour_rgb_b_min]		= 0;
			__grid[# i, __chitter_char.part_colour_rgb_b_max]		= 255;
			__grid[# i, __chitter_char.part_colour_hsv]			= false;
			__grid[# i, __chitter_char.part_colour_hsv_h_min]		= 0;
			__grid[# i, __chitter_char.part_colour_hsv_h_max]		= 255;
			__grid[# i, __chitter_char.part_colour_hsv_s_min]		= 0;
			__grid[# i, __chitter_char.part_colour_hsv_s_max]		= 255;
			__grid[# i, __chitter_char.part_colour_hsv_v_min]		= 0;
			__grid[# i, __chitter_char.part_colour_hsv_v_max]		= 255;
			__grid[# i, __chitter_char.part_colour1]				= -1;
			__grid[# i, __chitter_char.part_colour2]				= false;
			__grid[# i, __chitter_char.part_colour2_1]				= 0;
			__grid[# i, __chitter_char.part_colour2_2]				= 0;
			__grid[# i, __chitter_char.part_colour3]				= false;
			__grid[# i, __chitter_char.part_colour3_1]				= 0;
			__grid[# i, __chitter_char.part_colour3_2]				= 0;
			__grid[# i, __chitter_char.part_colour3_3]				= 205;
			__grid[# i, __chitter_char.part_alpha1]				= 1;
			__grid[# i, __chitter_char.part_alpha2]				= false;
			__grid[# i, __chitter_char.part_alpha2_1]				= 1;
			__grid[# i, __chitter_char.part_alpha2_2]				= 0.5;
			__grid[# i, __chitter_char.part_alpha3]				= false;
			__grid[# i, __chitter_char.part_alpha3_1]				= 1;
			__grid[# i, __chitter_char.part_alpha3_2]				= 0.5;
			__grid[# i, __chitter_char.part_alpha3_3]				= 0.25;
			__grid[# i, __chitter_char.part_blend]					= -1;
			__grid[# i, __chitter_char.part_life]					= true;
			__grid[# i, __chitter_char.part_life_min]				= 1;
			__grid[# i, __chitter_char.part_life_max]				= 1;
			__grid[# i, __chitter_char.part_death]					= false;
			__grid[# i, __chitter_char.part_death_number]			= 0;
			__grid[# i, __chitter_char.part_death_type]			= 0;
			
			#endregion
			
		    _str_width += _str_wid;
		
		    if _breakwidth != undefined and _str_width > _breakwidth {
		        while _str_char != chr(ord(" ")) {
		            i--;
		            _str_char = string_char_at(_string, i + 1);
		        }
		        _str_breakline++
		        _str_width = 0;
		    }
		    _str_height = ceil(string_height(_str_char) * 0.75) * _str_breakline;
		}
	};
	
    /// @ignore
	static __text_modify = function(_list, _grid) {
		
		var _list_length = ds_list_size(_list)
		
		if _list_length = 0 { exit; }
		
		var _readjust_width = false;
		var _readjust_height = false;
		
				
		for (var i = 0; i < _list_length; ++i) {
    
		    var _arr_length = array_length(_list[| i].names)
    
		    for (var ii = 0; ii < _arr_length; ++ii) {
		        var _name = _list[| i].names[ii];
				
				var _index_start = _list[| i].start;
				var _index_end = _list[| i].finish;
				
		        for (var iii = _index_start; iii < _index_end; ++iii) {
					
		            var _index = struct_get(__chitter_struct, _name);
					
					if _index = undefined { continue; }
					
		            var _value = _list[| i].values[ii];				
					
					if _name == "rainbow" {
						_grid[# iii, __chitter_char.hue1] = -15 * iii * 0.5;
					}
					
					if _name == "color" {
						ds_grid_set(_grid, iii, __chitter_char.color1, _value);
						ds_grid_set(_grid, iii, __chitter_char.color2, _value);
						ds_grid_set(_grid, iii, __chitter_char.color3, _value);
						ds_grid_set(_grid, iii, __chitter_char.color4, _value);
						
					} else {
						ds_grid_set(_grid, iii, _index, _value);
					}
										
					if __font != _grid[# iii, __chitter_char.font] {
					
						draw_set_font(_grid[# iii, __chitter_char.font])
						var _str_wid_new = string_width(_grid[# iii, __chitter_char.char]);
						_grid[# iii + 1, __chitter_char.width] = _grid[# iii, __chitter_char.width] + _str_wid_new * __font_scale;
						_readjust_width = true;
					}
					
					if !_readjust_height and _grid[# iii, __chitter_char.line_break] {
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
															
					ds_grid_set(_grid, iii, __chitter_char.chmod, true);
					
					if __font_sprite != undefined and _grid[# iii, __chitter_char.particles] == true {
						
						var _id = _grid[# iii, __chitter_char.part_id];
						
						if _id == -1 { continue; }
						
						if !part_type_exists(__part_id[| _id]) {
							__part_id[| _id] = part_type_create();
						}						
												
						var _font =  _grid[# iii, __chitter_char.font];
						var _font_name = font_get_name(_font);
						__font_name = _font_name;
						var _sprite = _grid[# iii, __chitter_char.part_sprite] ? _grid[# iii, __chitter_char.part_sprite_image] : __font_sprite_struct[$ _font_name];
						_grid[# iii, __chitter_char.part_sprite_image] = _sprite;
							
						part_type_sprite(__part_id[| _id], 
											_grid[# iii, __chitter_char.part_sprite_image],
											_grid[# iii, __chitter_char.part_sprite_animate],
											_grid[# iii, __chitter_char.part_sprite_stretch],
											_grid[# iii, __chitter_char.part_sprite_random]);
						
						if ds_grid_get(_grid, iii, __chitter_char.part_direction) == true {
							
							part_type_direction(__part_id[| _id], 
											 _grid[# iii, __chitter_char.part_direction_min],
											 _grid[# iii, __chitter_char.part_direction_max],
											 _grid[# iii, __chitter_char.part_direction_incr],
											 _grid[# iii, __chitter_char.part_direction_wiggle]);
						}
						
						if ds_grid_get(_grid, iii, __chitter_char.part_speed) == true {
							part_type_speed(__part_id[| _id], 
											 _grid[# iii, __chitter_char.part_speed_min],
											 _grid[# iii, __chitter_char.part_speed_max],
											 _grid[# iii, __chitter_char.part_speed_incr],
											 _grid[# iii, __chitter_char.part_speed_wiggle]);
						}
						
						if ds_grid_get(_grid, iii, __chitter_char.part_scale) == true {
							part_type_scale(__part_id[| _id], 
											 _grid[# iii, __chitter_char.part_scale_x],
											 _grid[# iii, __chitter_char.part_scale_y]);
						}
						
						if ds_grid_get(_grid, iii, __chitter_char.part_life) == true {
							part_type_life(__part_id[| _id], 
										   _grid[# iii, __chitter_char.part_life_min],
										   _grid[# iii, __chitter_char.part_life_max]);								
						}
						
						if ds_grid_get(_grid, iii, __chitter_char.part_colour1) != -1 {
							part_type_colour1(__part_id[| _id], _grid[# iii, __chitter_char.part_colour1]);								
						}
						
						if ds_grid_get(_grid, iii, __chitter_char.part_colour2) == true {
							part_type_colour2(__part_id[| _id], 
											  _grid[# iii, __chitter_char.part_colour2_1],							
											  _grid[# iii, __chitter_char.part_colour2_2]);								
						}
						
						if ds_grid_get(_grid, iii, __chitter_char.part_colour3) == true {
							part_type_colour3(__part_id[| _id], 
											  _grid[# iii, __chitter_char.part_colour3_1],							
											  _grid[# iii, __chitter_char.part_colour3_2],								
											  _grid[# iii, __chitter_char.part_colour3_3]);								
						}
						
						if ds_grid_get(_grid, iii, __chitter_char.part_colour_mix) == true {
							part_type_colour_mix(__part_id[| _id], 
												 _grid[# iii, __chitter_char.part_colour_mix_1],							
												 _grid[# iii, __chitter_char.part_colour_mix_2]);								
						}
												
						if ds_grid_get(_grid, iii, __chitter_char.part_colour_hsv) == true {
							part_type_colour_hsv(__part_id[| _id], 
												 _grid[# iii, __chitter_char.part_colour_hsv_h_min],
												 _grid[# iii, __chitter_char.part_colour_hsv_h_max],
												 _grid[# iii, __chitter_char.part_colour_hsv_s_min],
												 _grid[# iii, __chitter_char.part_colour_hsv_s_max],
												 _grid[# iii, __chitter_char.part_colour_hsv_v_min],		
												 _grid[# iii, __chitter_char.part_colour_hsv_v_max]);
						}
												
						if ds_grid_get(_grid, iii, __chitter_char.part_colour_rgb) == true {
							part_type_colour_rgb(__part_id[| _id], 
												 _grid[# iii, __chitter_char.part_colour_rgb_r_min],
												 _grid[# iii, __chitter_char.part_colour_rgb_r_max],
												 _grid[# iii, __chitter_char.part_colour_rgb_g_min],
												 _grid[# iii, __chitter_char.part_colour_rgb_g_max],
												 _grid[# iii, __chitter_char.part_colour_rgb_b_min],		
												 _grid[# iii, __chitter_char.part_colour_rgb_b_max]);
						}
						
						if ds_grid_get(_grid, iii, __chitter_char.part_alpha1) != -1 {
							part_type_alpha1(__part_id[| _id], _grid[# iii, __chitter_char.part_alpha1]);								
						}
						
						if ds_grid_get(_grid, iii, __chitter_char.part_alpha2) == true {
							part_type_alpha2(__part_id[| _id], 
											 _grid[# iii, __chitter_char.part_alpha2_1],							
											 _grid[# iii, __chitter_char.part_alpha2_2]);								
						}
						
						if ds_grid_get(_grid, iii, __chitter_char.part_alpha3) == true {
							part_type_alpha3(__part_id[| _id], 
											 _grid[# iii, __chitter_char.part_alpha3_1],							
											 _grid[# iii, __chitter_char.part_alpha3_2],								
											 _grid[# iii, __chitter_char.part_alpha3_3]);								
						}
						
						if ds_grid_get(_grid, iii, __chitter_char.part_gravity) == true {
							part_type_gravity(__part_id[| _id], 
											  _grid[# iii, __chitter_char.part_gravity_amount],							
											  _grid[# iii, __chitter_char.part_gravity_direction]);								
						}
						
						if ds_grid_get(_grid, iii, __chitter_char.part_blend) != -1 {
							part_type_blend(__part_id[| _id], _grid[# iii, __chitter_char.part_blend]);
						}
				
						if ds_grid_get(_grid, iii, __chitter_char.part_orientation) == true {
							part_type_orientation(__part_id[| _id], 
												  _grid[# iii, __chitter_char.part_orientation_min],
												  _grid[# iii, __chitter_char.part_orientation_max],
												  _grid[# iii, __chitter_char.part_orientation_incr],
												  _grid[# iii, __chitter_char.part_orientation_wiggle],
												  _grid[# iii, __chitter_char.part_orientation_relative]);
						}
				
						if ds_grid_get(_grid, iii, __chitter_char.part_size) == true {
							part_type_size(__part_id[| _id], 
										   _grid[# iii, __chitter_char.part_size_min],
										   _grid[# iii, __chitter_char.part_size_max],
										   _grid[# iii, __chitter_char.part_size_incr],
										   _grid[# iii, __chitter_char.part_size_wiggle]);
						}
				
						if ds_grid_get(_grid, iii, __chitter_char.part_size_x) == true {
							part_type_size_x(__part_id[| _id], 
											 _grid[# iii, __chitter_char.part_size_x_min],
											 _grid[# iii, __chitter_char.part_size_x_max],
											 _grid[# iii, __chitter_char.part_size_x_incr],
											 _grid[# iii, __chitter_char.part_size_x_wiggle]);
						}
				
						if ds_grid_get(_grid, iii, __chitter_char.part_size_y) == true {
							part_type_size_y(__part_id[| _id], 
											 _grid[# iii, __chitter_char.part_size_y_min],
											 _grid[# iii, __chitter_char.part_size_y_max],
											 _grid[# iii, __chitter_char.part_size_y_incr],
											 _grid[# iii, __chitter_char.part_size_y_wiggle]);
						}						
						
					}
					
		        }
				
				if _readjust_width {
					var _i = _index_end;
					if _i >= __string_length { continue}
					draw_set_font(_grid[# _i, __chitter_char.font]);
					_grid[# iii, __chitter_char.width] = _grid[# iii, __chitter_char.width] + string_width(_grid[# iii, __chitter_char.char]);
					for (var iii = _list[| i].finish; iii <= __string_length; ++iii) {
						
						var _str_wid_new = string_width(_grid[# iii, __chitter_char.char]);
						_grid[# iii + 1, __chitter_char.width] = _grid[# iii, __chitter_char.width] + _str_wid_new * __font_scale;
					}
					_readjust_width = false;
				}
				
				if _readjust_height {
					
					draw_set_font(_grid[# iii - 1, __chitter_char.font])
					
					for (var iii = _list[| i].start; iii <= __string_length; ++iii) {
						var _str_hgt_new = ceil(string_height(_grid[# iii, __chitter_char.char]));
						
						_grid[# iii, __chitter_char.height] = _grid[# iii, __chitter_char.height] + _str_hgt_new;
						
					}
					
					var _width_new = _grid[# _list[| i].start, __chitter_char.char] != " " ? 0 : -string_width(" ");
					
					_grid[# _list[| i].start, __chitter_char.width] = _width_new;
					
					for (var iii = _list[| i].start; iii <= __string_length; ++iii) {
						
						
						var _str_wid_new = string_width(_grid[# iii, __chitter_char.char]);
						_grid[# iii, __chitter_char.width] = _width_new;
						_width_new += _str_wid_new * __font_scale;

					}
					_readjust_height = false;
				}
		    }
		}
	}
	
    /// @ignore
	static __text_list_clean = function(_list) {
		
		var _ds_length = ds_list_size(_list);
		
		var _ds_list = ds_list_create();
		
		var _reduction_amount = 0;
		
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

		        if _name == "color" or 
				   _name == "color1" or 
				   _name == "color2" or 
				   _name == "color3" or 
				   _name == "color4" or 
				   _name == "part_colour_mix_1" or
				   _name == "part_colour_mix_2" or
				   _name == "part_colour1" or 
				   _name == "part_colour2_1" or 
				   _name == "part_colour2_2" or 
				   _name == "part_colour3_1" or 
				   _name == "part_colour3_2" or 
				   _name == "part_colour3_3" {
					if string_starts_with(_values[ii], "#") or string_letters(_values[ii]) != "" {
						var _hex = __hex_to_color(_values[ii]);
						_values[ii] = _hex;
					} else {
						var _real = _values[ii];
						_values[ii] = real(_real);
					}
		        } else {
		            var _real = _values[ii];
		            _values[ii] = real(_real);
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
			var _premod = __chitter_premod_names[_i]
			if string_pos(_premod, _string_new) != 0 {
				_string_new = string_replace(_string_new, _premod, __chitter_premod[$ _premod]);
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
			
			if ord(_identifier) == 13 {
				_string_new = string_replace(_string_new, chr(10), "");
				_string_new = string_replace(_string_new, chr(13), "[line_break : true] []");
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
					            
		            if _identifier == " " { 
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
		return _modifier_list
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
	static __hex_to_color = function(_string) {
		
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

	    var _R1 = _max_r / _base * struct_get(_struct_hex, string_char_at(_string_upper, 1));
	    var _R2 = _max_r / _ddig * struct_get(_struct_hex, string_char_at(_string_upper, 2));
	    var _G1 = _max_g / _base * struct_get(_struct_hex, string_char_at(_string_upper, 3));
	    var _G2 = _max_g / _ddig * struct_get(_struct_hex, string_char_at(_string_upper, 4));
	    var _B1 = _max_b / _base * struct_get(_struct_hex, string_char_at(_string_upper, 5));
	    var _B2 = _max_b / _ddig * struct_get(_struct_hex, string_char_at(_string_upper, 6));
    
	    return (_R1 + _R2 + _G1 + _G2 + _B1 + _B2);
	}
	
	/// @ignore
	static __font_to_spr = function(_font, _range_min, _range_max) { 

		draw_set_halign(fa_left);	
	    draw_set_valign(fa_middle);
		
	    draw_set_font(_font);
		var _size = font_get_size(_font) * 2;
	    var _ind = _range_min;
	    var _len = _range_max - _range_min;
	    var _surf_wh = _size * 2;
	    var _draw_w = 0;
	    var _draw_h = _size * 0.5;
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
