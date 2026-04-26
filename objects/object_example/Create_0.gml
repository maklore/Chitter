show_debug_overlay(true)

Chitter().initialise(font_example_1);

Chitter().add("Example", 
sprite_example, 
@"Welcome to [rainbow : true]Chitter![]
A queue based [wave_y : true, wave_amp : 1]text rendering[] system.

Where changing colors to [color : #0000ff]blue[] or [color : #ff0000]red[] is simple!
And using [particles : true, part_id : 3, part_colour2 : true, part_colour2_1 : #FFFFFF, part_colour2_2 : #000000, part_life : true, part_life_min : 5, part_life_max : 20, part_direction : true, part_direction_min : 80, part_direction_max : 100, part_direction_increase : 1, part_speed : true, part_speed_min : 0.01, part_speed_max : 1]particles[] is complex...

Please do read Chitter_documentation
to learn how to use this system!

Also [part_freezing]fear[] not, for you can predefine [direction : true, direction_curve_level : 5]modifiers![]
See Chitter_predefined_mods for more info."
);

Chitter().next()