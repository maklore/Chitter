show_debug_overlay(true)
display_set_gui_size(1920, 1080);

Chitter().initialise(font_example_1);

Chitter().add(
@"Welcome to [rainbow : true]Chitter![]
A [wave_y : true, wave_amp : 3]text modification[] system.

Where changing colors to [color : #0000ff]blue[] or [color : #ff0000]red[] is light.
And using [particles : true, part_id : 0, part_colour2 : true, part_colour2_1 : #FFFFFF, part_colour2_2 : #000000, part_life : true, part_life_min : 2, part_life_max : 15, part_direction : true, part_direction_min : 80, part_direction_max : 100, part_direction_increase : 1, part_speed : true, part_speed_min : 1, part_speed_max : 1]particles[] is heavy...

Please do read Chitter_documentation
to learn how to use this system!

Also [part_freezing]fear[] not, for you can predefine [direction : true, direction_curve_level : 5]modifiers![]
See Chitter_predefined_mods for more info."
);

//Chitter().next()