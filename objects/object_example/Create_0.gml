display_set_gui_size(1920, 1080);

Chitter().initialise(font_example_1, sound_example);

Chitter().add(
@"I feel so [part_id : 0, PART_burn_static]HOT![]

I feel so [part_id : 1, PART_freezing]cold![]

I am loosing my [part_id : 2, PART_insane]mind..[]

I am [rainbow : true, rainbow_backward : false, direction : true, direction_angle : 32, direction_curve_level : -8]Fabulous![]

")


Chitter().add(
@"Welcome to [SDF_rainbow_quad]Chitter![]

A [rotation_oscillate : true, rotation_oscillate_angle : -1, rotation_oscillate_frq : 800, rotation_oscillate_amp : 10, rotation_oscillate_sep : 0.125, wave_y : true, wave_frq : 800, wave_amp : 10, wave_sep : 0.5]text modification[] system.

Where changing colours to [colour : #0000ff]blue[] or [colour : #ff0000]red[] is light.[write_speed : 0.01] []
[part_id : 0, PART_insane, part_fade_out : true, part_fade_frames : 30]And using particles is heavy...[]");

