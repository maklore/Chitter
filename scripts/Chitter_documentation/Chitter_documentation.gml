/*

*WORK IN PROGRESS*

Welcome to Chitter!!

This is a text rendering system that places modified strings in a queue.

Each font asset will be turned into sprites for use automatically when initialised.

Please hover over the functions when added to read what they do.

**** INITIALISE ****

To begin using Chitter, create an object and add this: Chitter().initialise() 
to the create event and fill in the arguments that are required.

**** ADD ****

To add strings to the queue, add this: Chitter().add()
to the create event as well and fill in the arguments that are required.

Using the tags listed below you can modify strings when using .add() to make the drawn text 
behave differently than it otherwise would have.

How to modify a string:
"Here is a [color : #0000ff]blue[] color."

This will make the word "blue" draw in a blue color.

**** NEXT ****

To begin the queue and send modified string to be drawn or to skip and view the whole text, add: Chitter().next()
to the step even, preferably with some sort of trigger like:

if keyboard_check_pressed(KEY) {
	Chitter().next();
}

Also Chitter().next() returns true if there more in the queue or false if the queue is empty.

**** DRAW ****

To draw the text from the queue add: Chitter().draw()
to the draw gui event, and fill in the arguments to set
the draw position.

**** SOUND ****

Chitter().sound() plays a sound for each letter if sound has been initialised.

Add it to the step event to play sound.

**** TALKER ****

Chitter().talker() returns string name of the active talker.

**** SPRITE ****

Chitter().sprite() returns the sprite of the active talker, or the sprite added through modifier tags.

**** CLEANUP ****

Chitter().cleanup() clears the queue and removes font sprite added at runtime from memory.

**** ADDITIONAL INFO ****

You can also use particles to affect text.
Though it requires font turned into a sprite.

For each unique particles effect you must increase the number or use one not used before.

Example: 

"[particles : true, part_id : 0, part_scale : true, part_scale_x : 2]Hello []world!"

"Hello [particles : true, part_id : 1, part_scale : true, part_scale_y : 2]world! []"

You can also predefine modifications.

Check out Chitter_predefined_mods for examples.

**** MODIFIERS ****

Comprehensive list of currently available tags and value types:

//####**** DRAW TEXT ****####\\
draw_text : BOOLEAN

//####**** LINE BREAK ****####\\
line_break : REAL

//####**** ALPHA ****####\\
alpha : REAL

//####**** COLOR ****####\\
color  : HEX (#000000) OR REAL
color1 : HEX (#000000) OR REAL
color2 : HEX (#000000) OR REAL
color3 : HEX (#000000) OR REAL
color4 : HEX (#000000) OR REAL

//####**** SCALE ****####\\
scale   : REAL
scale_x : REAL
scale_y : REAL

//####**** WAVE ****####\\
wave_x : BOOLEAN
wave_y : BOOLEAN

wave_frq : REAL
wave_amp : REAL
wave_sep : REAL

//####**** PULSATE ****####\\
pulsate_x : BOOLEAN
pulsate_y : BOOLEAN

pulsate_frq : REAL
pulsate_amp : REAL
pulsate_sep : REAL

//####**** SHAKE ****####\\
shake_x : BOOLEAN
shake_y : BOOLEAN

shake_amount

//####**** DISCO ****####\\
disco : BOOLEAN

disco_red   : REAL (0 - 255)
disco_green : REAL (0 - 255)
disco_blue  : REAL (0 - 255)

//####**** RAINBOW ****####\\
rainbow : BOOLEAN

rainbow_speed : REAL

//####**** Typewriter ****####\\
typewriter : BOOL
Default is true.

//####**** WRITE SPEED ****####\\
write_speed : REAL

//####**** ROTATION ****####\\
rotation : BOOLEAN

rotation_angle : REAL
rotation_speed : REAL
rotation_oscillate : BOOLEAN
rotation_oscillate_angle : REAL
rotation_oscillate_frq	 : REAL
rotation_oscillate_amp	 : REAL
rotation_oscillate_sep	 : REAL

//####**** DIRECTION ****####\\
direction : BOOLEAN

direction_angle : REAL
direction_curve_level : REAL

//####**** SOUND ****####\\
sound : BOOLEAN

sound_index         : GMAsset.sound
sound_priority      : REAL
sound_loop          : BOOLEAN
sound_gain          : REAL
sound_gain_low      : REAL
sound_gain_high     : REAL
sound_gain_random   : BOOLEAN
sound_offset        : REAL
sound_offset_low    : REAL
sound_offset_high   : REAL
sound_offset_random : BOOLEAN
sound_pitch         : REAL
sound_pitch_low     : REAL
sound_pitch_high    : REAL
sound_pitch_random  : BOOLEAN

//####**** TALKER ****####\\
talker : STRING
talker_sprite : GMAsset.sprite

//####**** PARTICLES ****####\\
particles : BOOLEAN

//####**** PARTICLES - ID ****####\\
part_id : REAL

//####**** PARTICLES - SPRITE ****####\\
part_sprite : BOOLEAN

part_sprite_image   : GMAsset.sprite
part_sprite_animate : BOOLEAN
part_sprite_stretch : BOOLEAN
part_sprite_random  : BOOLEAN

//####**** PARTICLES - SIZE ****####\\
part_size : BOOLEAN

part_size_min    : REAL
part_size_max    : REAL
part_size_incr   : REAL
part_size_wiggle : BOOLEAN

part_size_x
part_size_x_min    : REAL
part_size_x_max    : REAL
part_size_x_incr   : REAL
part_size_x_wiggle : BOOLEAN

part_size_y
part_size_y_min    : REAL
part_size_y_max    : REAL
part_size_y_incr   : REAL
part_size_y_wiggle : BOOLEAN

//####**** PARTICLES - SCALE ****####\\
part_scale : BOOLEAN

part_scale_x : REAL
part_scale_y : REAL

//####**** PARTICLES - SPEED ****####\\
part_speed        : BOOLEAN

part_speed_min    : REAL
part_speed_max    : REAL
part_speed_incr   : REAL
part_speed_wiggle : BOOLEAN

//####**** PARTICLES - DIRECTION ****####\\
part_direction : BOOLEAN

part_direction_min    : REAL
part_direction_max    : REAL
part_direction_incr   : REAL
part_direction_wiggle : BOOLEAN

//####**** PARTICLES - GRAVITY ****####\\
part_gravity : BOOLEAN

part_gravity_amount    : REAL
part_gravity_direction : REAL

//####**** PARTICLES - ORIENTATION ****####\\
part_orientation : BOOLEAN

part_orientation_min      : REAL
part_orientation_max      : REAL
part_orientation_incr     : REAL
part_orientation_wiggle   : BOOLEAN
part_orientation_relative : BOOLEAN

//####**** PARTICLES - COLOUR MIX ****####\\
part_colour_mix : BOOLEAN

part_colour_mix_1 : HEX (#000000) OR REAL
part_colour_mix_2 : HEX (#000000) OR REAL

//####**** PARTICLES - COLOUR RGB ****####\\
part_colour_rgb : BOOLEAN

part_colour_rgb_r_min : REAL (0 - 255)
part_colour_rgb_r_max : REAL (0 - 255)
part_colour_rgb_g_min : REAL (0 - 255)
part_colour_rgb_g_max : REAL (0 - 255)
part_colour_rgb_b_min : REAL (0 - 255)
part_colour_rgb_b_max : REAL (0 - 255)

//####**** PARTICLES - COLOUR HSV ****####\\
part_colour_hsv : BOOLEAN

part_colour_hsv_h_min : REAL (0 - 255)
part_colour_hsv_h_max : REAL (0 - 255)
part_colour_hsv_s_min : REAL (0 - 255)
part_colour_hsv_s_max : REAL (0 - 255)
part_colour_hsv_v_min : REAL (0 - 255)
part_colour_hsv_v_max : REAL (0 - 255)

//####**** PARTICLES - COLOUR1 ****####\\
part_colour1 : HEX (#000000)

//####**** PARTICLES - COLOUR2 ****####\\
part_colour2 : BOOLEAN

part_colour2_1 : HEX (#000000) OR REAL
part_colour2_2 : HEX (#000000) OR REAL

//####**** PARTICLES - COLOUR3 ****####\\
part_colour3 : BOOLEAN

part_colour3_1 : HEX (#000000) OR REAL
part_colour3_2 : HEX (#000000) OR REAL
part_colour3_3 : HEX (#000000) OR REAL

//####**** PARTICLES - ALPHA1 ****####\\
part_alpha1

//####**** PARTICLES - ALPHA2 ****####\\
part_alpha2 : BOOLEAN

part_alpha2_1 : REAL
part_alpha2_2 : REAL

//####**** PARTICLES - ALPHA3 ****####\\
part_alpha3 : BOOLEAN

part_alpha3_1 : REAL
part_alpha3_2 : REAL
part_alpha3_3 : REAL

//####**** PARTICLES - BLEND ****####\\
part_blend : BOOLEAN

//####**** PARTICLES - LIFE ****####\\
part_life : BOOLEAN

part_life_min : REAL
part_life_max : REAL

*/
