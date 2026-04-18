/* 
Adding string variables here allows you to predefine your own modification.
The variable name added like this "[rainbow_wave]Hello[] world!" will be replaced by the predefined value.
*/

function __chitter_premods() constructor {
	
	rainbow_wave = "rainbow : true, wave_y : true, wave_frq : 600, wave_amp : 2";
	freezing	 = "wave_x : true, wave_y : true, wave_amp : 2.8, particles : true, particles_id : 100, particles_colour3 : true, particles_colour3_1 : #0000ff, particles_colour3_2 : #00ffff, particles_colour3_3 : #ffffff, particles_life : true, particles_life_min : 3, particles_life_max : 3, particles_direction : true, particles_direction_min : 0, particles_direction_max : 360, particles_speed : true, particles_speed_min : 1, particles_speed_max : 2";
	angry		 = "shake_x : true, shake_y : true, shake_amount : 3, color : #ff0000";
	slow_wave	 = "wave_y : true, wave_amp : 20, wave_frq : 10000";
	insanity	 = "particles : true, particles_id : 101, particles_life : true, particles_life_min : 2, particles_life_max : 5, particles_direction : true, particles_direction_min : 0, particles_direction_max : 360, particles_direction_increase : 1, particles_speed : true, particles_speed_min : 1, particles_speed_max : 2";
}