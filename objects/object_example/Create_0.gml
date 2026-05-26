display_set_gui_size(1920, 1080);

Chitter().initialise(font_example_1, sound_example);

Chitter().add(
@"Welcome to [rainbow_sdf_quad]Chitter![]

A [rotation_oscillate : true, rotation_oscillate_angle : -1, rotation_oscillate_frq : 800, rotation_oscillate_amp : 10, rotation_oscillate_sep : 0.125, wave_y : true, wave_frq : 800, wave_amp : 10, wave_sep : 0.5]text modification[] system.

Where changing colours to [colour : #0000ff]blue[] or [colour : #ff0000]red[] is light.[write_speed : 0.01] []
[part_insane, part_fade_out : true, part_fade_frames : 30, part_id : 0]And using particles is heavy...[]"
);

