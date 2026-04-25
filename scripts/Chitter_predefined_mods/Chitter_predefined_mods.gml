/* 
Adding string variables here allows you to predefine your own modification.
The variable name added like this "[rainbow_wave]Hello[] world!" will be replaced by the predefined value.
DISCLAIMER, YOU CANNOT ADD PREMOD KEYS TO PREMODS!
*/

function __chitter_premods() constructor {
	
	rainbow_wave = "rainbow : true, wave_y : true, wave_frq : 600, wave_amp : 2";
	angry = "shake_x : true, shake_y : true, shake_amount : 3, color : #ff0000";
	slow_wave = "wave_y : true, wave_amp : 20, wave_frq : 10000";
	part_freezing = "wave_x : true, wave_y : true, wave_amp : 2.8, particles : true, part_id : 10, part_colour3 : true, part_colour3_1 : #0000ff, part_colour3_2 : #00ffff, part_colour3_3 : #ffffff, part_life : true, part_life_min : 3, part_life_max : 3, part_direction : true, part_direction_min : 0, part_direction_max : 360, part_speed : true, part_speed_min : 1, part_speed_max : 2";
	part_insanity = "particles : true, part_id : 11, part_life : true, part_life_min : 2, part_life_max : 5, part_direction : true, part_direction_min : 0, part_direction_max : 360, part_direction_increase : 1, part_speed : true, part_speed_min : 1, part_speed_max : 2";
	
}