display_set_gui_size(1920, 1080);

Chitter().initialise(font_example_1, c_ltgrey, sound_example, true);

Chitter().add(@"[PART_insane, part_fade_out : true, part_fade_frames : 10, part_id : 0]This is going to be quite[]
[part_id : 1, PART_insane]interesting don't you think?[]")


Chitter().add(
@"Chitter's so [part_id : 0, PART_burn_static]HOT![] 

Chitter's so [part_colour1 : #ffffff, part_id : 1, PART_freezing]cold![]

The [font : font_example_3]answer[] is [part_id : 2, part_sprite_random : true, part_fade_out : true, part_fade_frames : 120]Chitter...[]

This is [SDF_rainbow_quad, rainbow_backward : true, direction : true, direction_angle : 32, direction_curve_level : -8]Chitter![]

[pulsate_y : true, pulsate_frq : 1500, pulsate_amp : 0.2]Chitter[] [font : font_example_2]is[] acting [font : font_example_3]strange[]..");

Chitter().add(@"This is [SDF_rainbow_quad]going[] to be quite 
interesting don't you think?")