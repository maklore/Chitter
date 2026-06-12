function __chitter_base_struct(_chitter) constructor {
	
	chmod								= false;
	font_swap							= _chitter.__font;
	line_break							= false;
	
	offset_x							= 0;
	offset_y							= 0;
	offset_x_return_speed				= 0;
	offset_y_return_speed				= 0;
	
	hard_stop_frames					= 0;
	hard_stop_seconds					= 0;
	
	scale								= _chitter.__font_scale_base;
	scale_x								= 1 * _chitter.__font_scale_base;
	scale_y								= 1 * _chitter.__font_scale_base;
	
	typewriter							= true;
	write_speed							= 12;
	
	wait_frames							= 0;
	wait_seconds						= 0;
	
	hue1								= 255;
	hue2								= 0;
	
	colour								= _chitter.__font_colour_base;
	colour1								= _chitter.__font_colour_base;
	colour2								= _chitter.__font_colour_base;
	colour3								= _chitter.__font_colour_base;
	colour4								= _chitter.__font_colour_base;
	
	colour_merge						= false;
	colour_merge_1						= 0;
	colour_merge_2						= 0;
	colour_merge_amount					= 0;
	colour_random						= false;
	colour_random_red					= 255;
	colour_random_green					= 255;
	colour_random_blue					= 255;
	colour_random_fade_in				= false;
	colour_random_fade_out				= false;
	colour_random_fade_frames			= 0;
	colour_random_fade_target			= 0;
	
	wave								= false;
	wave_frq							= 800;
	wave_amp							= 5;
	wave_sep							= 1;
	wave_angle							= 90;
	wave_fade_in						= false;
	wave_fade_out						= false;
	wave_fade_frames					= 0;
	wave_fade_target					= 0;
	
	pulsate_x							= false;
	pulsate_y							= false;
	pulsate_frq							= 800;
	pulsate_amp							= 0.05;
	pulsate_sep							= 1;
	pulsate_fade_in						= false;
	pulsate_fade_out					= false;
	pulsate_fade_frames					= 0;
	pulsate_fade_target					= 0;
	
	shake_x								= false;
	shake_y								= false;
	shake_amount						= 5;
	shake_fade_in						= false;
	shake_fade_out						= false;
	shake_fade_frames					= 0;
	shake_fade_target					= 0;
	
	rotation							= false;
	rotation_angle						= 0;
	rotation_speed						= 0;
	rotation_fade_in					= false;
	rotation_fade_out					= false;
	rotation_fade_frames				= 0;
	rotation_fade_target				= 0;
	rotation_oscillate					= false;
	rotation_oscillate_angle			= 0;
	rotation_oscillate_frq				= 800;
	rotation_oscillate_amp				= 5;
	rotation_oscillate_sep				= 1;
	rotation_oscillate_fade_in			= false;
	rotation_oscillate_fade_out			= false;
	rotation_oscillate_fade_frames		= 0;
	rotation_oscillate_fade_target		= 0;
	
	direction							= false;
	direction_angle						= 0;
	direction_curve_level				= false;
	
	rainbow								= false;
	rainbow_backward					= false;
	rainbow_speed						= 1;
	rainbow_fade_in						= false;
	rainbow_fade_out					= false;
	rainbow_fade_frames					= 0;
	rainbow_fade_target					= 0;
	
	alpha								= 1;
	alpha_fade_in						= false;
	alpha_fade_out						= false;
	alpha_fade_frames					= 0;
	alpha_fade_target					= 0;
	alpha_wave							= false;
	alpha_wave_frq						= 2000;
	alpha_wave_amp						= 0.5;
	alpha_wave_sep						= 0.75;
	alpha_wave_fade_in					= false;
	alpha_wave_fade_out					= false;
	alpha_wave_fade_frames				= 0;
	alpha_wave_fade_target				= 0;
	
	alpha_random						= false;
	alpha_random_amount					= 1;
	alpha_random_fade_in				= false;
	alpha_random_fade_out				= false;
	alpha_random_range					= false;
	alpha_random_fade_frames			= 0;
	alpha_random_fade_target			= 0;
	alpha_random_range_min				= 1;
	alpha_random_range_max				= 1;
	alpha_random_range_fade_in			= false;
	alpha_random_range_fade_out			= false;
	alpha_random_range_fade_frames		= 0;
	alpha_random_range_fade_target		= 0;
	
	sdf 								= false;
	sdf_thickness						= 0;
	sdf_core_colour						= c_white;
	sdf_core_colour_random				= false;
	sdf_core_colour_random_red			= 255;
	sdf_core_colour_random_green		= 255;
	sdf_core_colour_random_blue			= 255;
	sdf_core_alpha						= 1;
	sdf_core_rainbow					= false;
	sdf_core_rainbow_speed				= 1;
	sdf_outline 						= false;
	sdf_outline_distance				= 0;
	sdf_outline_colour					= c_white;
	sdf_outline_colour_random			= false;
	sdf_outline_colour_random_red		= 255;
	sdf_outline_colour_random_green		= 255;
	sdf_outline_colour_random_blue		= 255;
	sdf_outline_alpha					= 1;
	sdf_outline_rainbow					= false;
	sdf_outline_rainbow_speed			= 1;
	sdf_glow							= false;
	sdf_glow_start						= 0;
	sdf_glow_end						= 0;
	sdf_glow_colour 					= c_white;
	sdf_glow_colour_random				= false;
	sdf_glow_colour_random_red			= 255;
	sdf_glow_colour_random_green		= 255;
	sdf_glow_colour_random_blue			= 255;
	sdf_glow_alpha						= 1;
	sdf_glow_rainbow					= false;
	sdf_glow_rainbow_speed				= 1;
	sdf_shadow							= false;
	sdf_shadow_softness 				= 0;
	sdf_shadow_offset_x 				= 0;
	sdf_shadow_offset_y 				= 0;
	sdf_shadow_colour					= c_white;
	sdf_shadow_colour_random			= false;
	sdf_shadow_colour_random_red		= 255;
	sdf_shadow_colour_random_green		= 255;
	sdf_shadow_colour_random_blue		= 255;
	sdf_shadow_alpha					= 1;
	sdf_shadow_rainbow					= false;
	sdf_shadow_rainbow_speed			= 1;
	
	sound_index							= _chitter.__sound;
	sound_priority						= 0;
	sound_loop							= false;
	sound_gain							= 0.1;
	sound_gain_low						= 0.01;
	sound_gain_high						= 0.02;
	sound_gain_random					= true;
	sound_offset						= 0;
	sound_offset_low					= 0;
	sound_offset_high					= 1;
	sound_offset_random					= false;
	sound_pitch							= 1;
	sound_pitch_low						= 0.8;
	sound_pitch_high					= 1.1;
	sound_pitch_random					= true;
	//sound_listener_mask				= __sound != undefined ? audio_sound_get_listener_mask(__sound) : 0;
	
	part								= false;
	
	part_id								= -1;
	
	part_number							= 1;
	
	part_offset_x						= 0;
	part_offset_y						= 0;
	part_offset_x_return_speed			= 0;
	part_offset_y_return_speed			= 0;
	
	part_fade_in						= false;
	part_fade_out						= false;
	part_fade_frames					= 0;
	part_fade_target					= 0;
	
	part_draw_text						= false;
	
	part_sprite							= false;
	part_sprite_image					= _chitter.__font_sprite_struct[$ font_get_name(_chitter.__font)];
	part_sprite_animate					= false;
	part_sprite_stretch					= false;
	part_sprite_random					= false;
	
	part_size							= false;
	part_size_min						= 0;
	part_size_max						= 0;
	part_size_incr						= 0;
	part_size_wiggle					= 0;
	
	part_size_x							= false;
	part_size_x_min						= 0;
	part_size_x_max						= 0;
	part_size_x_incr					= 0;
	part_size_x_wiggle					= 0;
	
	part_size_y							= false;
	part_size_y_min						= 0;
	part_size_y_max						= 0;
	part_size_y_incr					= 0;
	part_size_y_wiggle					= 0;
	
	part_scale							= true;
	part_scale_x						= _chitter.__font_scale_base;
	part_scale_y						= _chitter.__font_scale_base;
	
	part_speed							= false;
	part_speed_min						= 0;
	part_speed_max						= 0;
	part_speed_incr						= 0;
	part_speed_wiggle					= 0;
	
	part_direction						= false;
	part_direction_min					= 0;
	part_direction_max					= 0;
	part_direction_increase				= 0;
	part_direction_wiggle				= 0;
	
	part_gravity						= false;
	part_gravity_amount					= 0;
	part_gravity_direction				= false;
	
	part_orientation					= false;
	part_orientation_min				= 0;
	part_orientation_max				= 0;
	part_orientation_incr				= 0;
	part_orientation_wiggle				= 0;
	part_orientation_relative			= false;
    part_orientation_oscillate			= false;
	part_orientation_oscillate_angle	= 0;
	part_orientation_oscillate_frq		= 800;
	part_orientation_oscillate_amp		= 1;
	part_orientation_oscillate_sep		= 1;
	
	part_colour_mix						= false;
	part_colour_mix_1					= 0;
	part_colour_mix_2					= 0;
	
	part_colour_rgb						= false;
	part_colour_rgb_r_min				= 0;
	part_colour_rgb_r_max				= 255;
	part_colour_rgb_g_min				= 0;
	part_colour_rgb_g_max				= 255;
	part_colour_rgb_b_min				= 0;
	part_colour_rgb_b_max				= 255;
	
	part_colour_hsv						= false;
	part_colour_hsv_h_min				= 0;
	part_colour_hsv_h_max				= 255;
	part_colour_hsv_s_min				= 0;
	part_colour_hsv_s_max				= 255;
	part_colour_hsv_v_min				= 0;
	part_colour_hsv_v_max				= 255;
	
	part_colour1						= -1;
	
	part_colour2						= false;
	part_colour2_1						= 0;
	part_colour2_2						= 0;
	
	part_colour3						= false;
	part_colour3_1						= 0;
	part_colour3_2						= 0;
	part_colour3_3						= 0;
	
	part_colour_rainbow					= false;
	part_colour_rainbow_speed			= 1;
	part_colour_random					= false;
	part_colour_random_red				= 255;
	part_colour_random_green			= 255;
	part_colour_random_blue				= 255;
	
	part_alpha1							= 1;
	part_alpha2							= false;
	part_alpha2_1						= 1;
	part_alpha2_2						= 0.5;
	part_alpha3							= false;
	part_alpha3_1						= 1;
	part_alpha3_2						= 0.5;
	part_alpha3_3						= 0.25;
	
	part_blend							= -1;
	
	part_life							= true;
	part_life_min						= 1;
	part_life_max						= 1;
	
	part_death							= false;
	part_death_number					= 0;
	part_death_type						= 0;
	
	part_wave							= false;
	part_wave_frq						= 800;
	part_wave_amp						= 5;
	part_wave_sep						= 1;
	part_wave_angle						= 90;
	part_wave_fade_in					= false;
	part_wave_fade_out					= false;
	part_wave_fade_frames				= 0;
	part_wave_fade_target				= 0;
	
	part_pulsate_x						= false;
	part_pulsate_y						= false;
	part_pulsate_frq					= 800;
	part_pulsate_amp					= 0.05;
	part_pulsate_sep					= 1;
	part_pulsate_fade_in				= false;
	part_pulsate_fade_out				= false;
	part_pulsate_fade_frames			= 0;
	part_pulsate_fade_target			= 0;

}