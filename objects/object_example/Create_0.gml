show_debug_overlay(true)
display_set_gui_size(1920, 1080);

Chitter().initialise(font_example_1);

Chitter().add(
@"Welcome to [rainbow : true]Chitter![]
A [wave_y : true, wave_amp : 1]text modification[] system.

Where changing colors to [color : #0000ff]blue[] or [color : #ff0000]red[] is light.
And using [particles : true, part_id : 0, part_colour2 : true, part_colour2_1 : #FFFFFF, part_colour2_2 : #000000, part_life : true, part_life_min : 5, part_life_max : 10, part_direction : true, part_direction_min : 80, part_direction_max : 100, part_direction_increase : 1, part_speed : true, part_speed_min : 0.01, part_speed_max : 2]particles[] is heavy...

Please do read [font : font_example_2]Chitter_documentation[]
to learn how to use this system!

Also [shake_x : true, shake_y : true]fear[] not, for you can predefine [direction : true, direction_curve_level : 5]modifiers![]
See [font : font_example_2]Chitter_predefined_mods[] for more info."
);

//Chitter().next()