/* 
Adding string variables here allows you to predefine your own modification.
The variable name added like this "[rainbow_wave]Hello[] world!" will be replaced by the predefined value.
DISCLAIMER, YOU CANNOT ADD PREMOD KEYS TO PREMODS!
*/

function __chitter_premods() constructor {
	
	rainbow_wave = "rainbow : true, wave_y : true, wave_frq : 600, wave_amp : 2";
	rainbow_sdf_quad = "colour : #ffffff, sdf : true, sdf_core_rainbow : true, sdf_core_rainbow_speed : 0.5, sdf_outline : true, sdf_outline_rainbow : true, sdf_outline_rainbow_speed : 0.75, sdf_outline_distance : 3, sdf_glow : true, sdf_glow_rainbow : true, sdf_glow_rainbow_speed : 1, sdf_glow_start : 3, sdf_glow_end : 15, sdf_shadow : true, sdf_shadow_rainbow : true, sdf_shadow_rainbow_speed : 1.25, sdf_shadow_offset_x : 30, sdf_shadow_offset_y : 30, sdf_shadow_softness : 30";
	fuzzy_text = "colour : #ffffff, sdf : true, sdf_core_alpha : 0, sdf_shadow : true, sdf_shadow_colour : #ffffff, sdf_shadow_softness : 32, sdf_shadow_alpha : 0.25";
	angry_simple = "shake_x : true, shake_y : true, shake_amount : 10, colour : #ff0000";
	wave_slow = "wave_y : true, wave_amp : 20, wave_frq : 10000";
	part_freezing = "particles : true, part_colour3 : true, part_colour3_1 : #0000ff, part_colour3_2 : #00ffff, part_colour3_3 : #ffffff, part_life : true, part_life_min : 2, part_life_max : 5, part_direction : true, part_direction_min : 0, part_direction_max : 180, part_speed : true, part_speed_min : 1, part_speed_max : 2";
	part_insane = "part_colour_random : true, part_colour_random_red : 150, part_colour_random_blue : 0, part_colour_random_green : 0, particles : true, part_life : true, part_life_min : 2, part_life_max : 5, part_direction : true, part_direction_min : 0, part_direction_max : 360, part_direction_increase : 1, part_speed : true, part_speed_min : 2, part_speed_max : 3";
	part_burn = "alpha : 0, particles : true, part_fade_out : true, part_fade_frames : 60, part_colour3 : true, part_colour3_1 : #FFFFFF, part_colour3_2 : #0F0F00, part_colour3_3 : #FF0000, part_life : true, part_life_min : 2, part_life_max : 15, part_direction : true, part_direction_min : 80, part_direction_max : 100, part_direction_increase : 1, part_speed : true, part_speed_min : 1, part_speed_max : 2";
	part_burn_black_small = "particles : true, part_colour3 : true, part_colour3_1 : #000000, part_colour3_2 : #FF0500, part_colour3_3 : #FFFFFF, part_life : true, part_life_min : 1, part_life_max : 15, part_direction : true, part_direction_min : 80, part_direction_max : 100, part_direction_increase : 1, part_speed : true, part_speed_min : 0, part_speed_max : 1";
	part_burn_to_char = "colour : #000000, particles : true, part_fade_out : true, part_fade_frames : 60, part_colour3 : true, part_colour3_1 : #FFFFFF, part_colour3_2 : #0F0F00, part_colour3_3 : #FF0000, part_life : true, part_life_min : 2, part_life_max : 15, part_direction : true, part_direction_min : 80, part_direction_max : 100, part_direction_increase : 1, part_speed : true, part_speed_min : 2, part_speed_max : 4";
}