/*

*WORK IN PROGRESS*

Welcome to Chitter!!

This is a text rendering system that places modified strings in a queue.

Please hover over the functions when added to read what they do.

**** INITIALIZE ****

To begin using Chitter, create an object and add this: Chitter().initialize() 
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

Chitter().sound() plays a sound for each letter if sound has been initialized.

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

Sidenote:
A minor bug when only using particle tags effects.
You need a space between the last modified string and the closing bracket to work properly...

Example: 

"[particles : true, particles_id : 0, particles_scale : true, particles_scale_x : 2]Hello []world!"

"Hello [particles : true, particles_id : 0, particles_scale : true, particles_scale_x : 2]world! []"

To predefine modifications see Chitter_predefined_mods.

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

//####**** WRITE SPEED ****####\\
write_speed : REAL

//####**** ROTATION ****####\\
rotation : BOOLEAN

rotation_angle : REAL
rotation_speed : REAL

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

//####**** PARTICLES (REQUIRES INITIALISE SPRITEFIED TO BE ENABLED OR CUSTOM SPRITE FONT TO BE ADDED) ****####\\
particles : BOOLEAN

//####**** PARTICLES - ID ****####\\
particles_id : REAL

//####**** PARTICLES - SPRITE ****####\\
particles_sprite : BOOLEAN

particles_sprite_image   : GMAsset.sprite
particles_sprite_animate : BOOLEAN
particles_sprite_stretch : BOOLEAN
particles_sprite_random  : BOOLEAN

//####**** PARTICLES - SIZE ****####\\
particles_size : BOOLEAN

particles_size_min    : REAL
particles_size_max    : REAL
particles_size_incr   : REAL
particles_size_wiggle : BOOLEAN

particles_size_x
particles_size_x_min    : REAL
particles_size_x_max    : REAL
particles_size_x_incr   : REAL
particles_size_x_wiggle : BOOLEAN

particles_size_y
particles_size_y_min    : REAL
particles_size_y_max    : REAL
particles_size_y_incr   : REAL
particles_size_y_wiggle : BOOLEAN

//####**** PARTICLES - SCALE ****####\\
particles_scale : BOOLEAN

particles_scale_x : REAL
particles_scale_y : REAL

//####**** PARTICLES - SPEED ****####\\
particles_speed        : BOOLEAN

particles_speed_min    : REAL
particles_speed_max    : REAL
particles_speed_incr   : REAL
particles_speed_wiggle : BOOLEAN

//####**** PARTICLES - DIRECTION ****####\\
particles_direction : BOOLEAN

particles_direction_min    : REAL
particles_direction_max    : REAL
particles_direction_incr   : REAL
particles_direction_wiggle : BOOLEAN

//####**** PARTICLES - GRAVITY ****####\\
particles_gravity : BOOLEAN

particles_gravity_amount    : REAL
particles_gravity_direction : REAL

//####**** PARTICLES - ORIENTATION ****####\\
particles_orientation : BOOLEAN

particles_orientation_min      : REAL
particles_orientation_max      : REAL
particles_orientation_incr     : REAL
particles_orientation_wiggle   : BOOLEAN
particles_orientation_relative : BOOLEAN

//####**** PARTICLES - COLOUR MIX ****####\\
particles_colour_mix : BOOLEAN

particles_colour_mix_1 : HEX (#000000) OR REAL
particles_colour_mix_2 : HEX (#000000) OR REAL

//####**** PARTICLES - COLOUR RGB ****####\\
particles_colour_rgb : BOOLEAN

particles_colour_rgb_r_min : REAL (0 - 255)
particles_colour_rgb_r_max : REAL (0 - 255)
particles_colour_rgb_g_min : REAL (0 - 255)
particles_colour_rgb_g_max : REAL (0 - 255)
particles_colour_rgb_b_min : REAL (0 - 255)
particles_colour_rgb_b_max : REAL (0 - 255)

//####**** PARTICLES - COLOUR HSV ****####\\
particles_colour_hsv : BOOLEAN

particles_colour_hsv_h_min : REAL (0 - 255)
particles_colour_hsv_h_max : REAL (0 - 255)
particles_colour_hsv_s_min : REAL (0 - 255)
particles_colour_hsv_s_max : REAL (0 - 255)
particles_colour_hsv_v_min : REAL (0 - 255)
particles_colour_hsv_v_max : REAL (0 - 255)

//####**** PARTICLES - COLOUR1 ****####\\
particles_colour1 : HEX (#000000)

//####**** PARTICLES - COLOUR2 ****####\\
particles_colour2 : BOOLEAN

particles_colour2_1 : HEX (#000000) OR REAL
particles_colour2_2 : HEX (#000000) OR REAL

//####**** PARTICLES - COLOUR3 ****####\\
particles_colour3 : BOOLEAN

particles_colour3_1 : HEX (#000000) OR REAL
particles_colour3_2 : HEX (#000000) OR REAL
particles_colour3_3 : HEX (#000000) OR REAL

//####**** PARTICLES - ALPHA1 ****####\\
particles_alpha1

//####**** PARTICLES - ALPHA2 ****####\\
particles_alpha2 : BOOLEAN

particles_alpha2_1 : REAL
particles_alpha2_2 : REAL

//####**** PARTICLES - ALPHA3 ****####\\
particles_alpha3 : BOOLEAN

particles_alpha3_1 : REAL
particles_alpha3_2 : REAL
particles_alpha3_3 : REAL

//####**** PARTICLES - BLEND ****####\\
particles_blend : BOOLEAN

//####**** PARTICLES - LIFE ****####\\
particles_life : BOOLEAN

particles_life_min : REAL
particles_life_max : REAL

*/
