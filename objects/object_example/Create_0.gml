show_debug_overlay(true)
display_set_gui_size(1920, 1080);

_x2 = 0;
_y2 = 0;
_padding = 26;

Chitter().initialise(font_example_1, sound_example);

Chitter().add(
@"Welcome to [rainbow : true]Chitter![]
A [wave_y : true, wave_fade_out : 1, wave_fade_spd : 0.5, wave_frq : 1000, wave_amp : 10, wave_sep : 0.5, wave_frq : 4000]text modification[] system.

Where changing colors to [color : #0000ff]blue[] or [color : #ff0000]red[] is light.
And using [particles : true, part_id : 0, part_fade_out : 1, part_fade_spd : 0.001, part_colour2 : true, part_colour2_1 : #FFFFFF, part_colour2_2 : #000000, part_life : true, part_life_min : 2, part_life_max : 15, part_direction : true, part_direction_min : 80, part_direction_max : 100, part_direction_increase : 1, part_speed : true, part_speed_min : 1, part_speed_max : 1]particles[] is heavy...

Please do read Chitter_documentation
to learn how to use this system!

Also[write_speed : 0.01] [][part_burning, part_id : 1, part_fade_out : 1, part_fade_spd : 0.01, write_speed : 1]FEAR[][write_speed : 0.01] []not, for you can predefine [direction : true, direction_curve_level : 5]modifiers![]
See Chitter_predefined_mods."
);

//Chitter().next()