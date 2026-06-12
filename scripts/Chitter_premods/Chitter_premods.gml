/* 
Adding modifier tags here, allow you to predefine your own modification.
Adding the predefined  "[rainbow_wave]Hello[] world!" will be replaced by the predefined value.
Here are some examples you can use.
*/

function __chitter_premods() constructor {
	
	rainbow_wave = "rainbow, wave, wave_frq : 600, wave_amp : 2";
	
	SDF_rainbow_quad = "colour : #ffffff, sdf, sdf_core_rainbow, sdf_core_rainbow_speed : 0.5, sdf_outline, sdf_outline_rainbow, sdf_outline_rainbow_speed : 0.75, sdf_outline_distance : 3, sdf_glow, sdf_glow_rainbow, sdf_glow_rainbow_speed : 1, sdf_glow_start : 3, sdf_glow_end : 15, sdf_shadow, sdf_shadow_rainbow, sdf_shadow_rainbow_speed : 1.25, sdf_shadow_offset_x : 30, sdf_shadow_offset_y : 30, sdf_shadow_softness : 30";
	
	SDF_fuzzy_text = "colour : #ffffff, sdf, sdf_core_alpha : 0, sdf_shadow, sdf_shadow_colour : #ffffff, sdf_shadow_softness : 32, sdf_shadow_alpha : 0.25";
	
	PART_freezing = "part, part_colour3, part_colour3_1 : #ffffff, part_colour3_2 : #00ffff, part_colour3_3 : #0000ff, part_life, part_life_min : 2, part_life_max : 5, part_direction, part_direction_min : 0, part_direction_max : 180, part_speed, part_speed_min : 1, part_speed_max : 2";
	
	PART_enraged = "part, part_colour_random, part_colour_random_red : 150, part_colour_random_blue : 0, part_colour_random_green : 0, part_life, part_life_min : 2, part_life_max : 5, part_direction , part_direction_min : 0, part_direction_max : 360, part_direction_increase : 1, part_speed, part_speed_min : 2, part_speed_max : 3";
	
	PART_burn_away = "alpha : 0, part, part_fade_out, part_fade_frames : 60, part_colour3, part_colour3_1 : #FFFFFF, part_colour3_2 : #F0F000, part_colour3_3 : #FF0000, part_life, part_life_min : 2, part_life_max : 15, part_direction, part_direction_min : 80, part_direction_max : 100, part_direction_increase : 1, part_speed, part_speed_min : 1, part_speed_max : 2";
	
	PART_burn_static = "part, part_colour3, part_colour3_1 : #FFFFFF, part_colour3_2 : #F0F000, part_colour3_3 : #FF0000, part_life, part_life_min : 2, part_life_max : 15, part_direction, part_direction_min : 80, part_direction_max : 100, part_direction_increase : 1, part_speed, part_speed_min : 2, part_speed_max : 4";
	
	PART_burn_black_small = "part, part_colour3, part_colour3_1 : #000000, part_colour3_2 : #FF5000, part_colour3_3 : #FFFFFF, part_life, part_life_min : 1, part_life_max : 15, part_direction, part_direction_min : 80, part_direction_max : 100, part_direction_increase : 1, part_speed, part_speed_min : 0, part_speed_max : 1";
	
	PART_burn_to_char = "colour : #000000, sdf, sdf_core_alpha : 0, sdf_shadow, sdf_shadow_colour : #ffffff, sdf_shadow_softness : 32, sdf_shadow_alpha : 0.25, part, part_draw_text, part_fade_out, part_fade_frames : 60, part_colour3, part_colour3_1 : #FFFFFF, part_colour3_2 : #F0F000, part_colour3_3 : #FF0000, part_life, part_life_min : 2, part_life_max : 15, part_direction, part_direction_min : 80, part_direction_max : 100, part_direction_increase : 1, part_speed, part_speed_min : 2, part_speed_max : 4";

	PART_dark_rainbow_fall = "colour : #000000, wave, part, part_wave, part_draw_text, part_gravity, part_gravity_amount : 0.5, part_gravity_direction : 270, part_life, part_life_max : 10, part_direction, part_speed, part_speed_max : 2, part_alpha3, part_alpha3_1 : 0.125, part_alpha3_2 : 0.25, part_alpha3_3 : 0.5, part_colour_rainbow";

}