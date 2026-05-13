<sub>(**WORK IN PROGRESS**)</sub>

# Welcome to Chitter!

This is a text altering system that adds modified strings to a queue.

<sub>Works only with monospace font for now.</sub>
<br></br>
### Examples:

![](https://github.com/maklore/Chitter/blob/main/gifs/weird.gif)

![](https://github.com/maklore/Chitter/blob/main/gifs/rainbow.gif)

![](https://github.com/maklore/Chitter/blob/main/gifs/burn.gif)

![](https://github.com/maklore/Chitter/blob/main/gifs/insanity.gif)

<br></br>
## .initialise(fontASSET, [soundASSET], [breakWidth])

```gml
Chitter().initialise(fontASSET);
```

Initialises Chitter's queue system, and creates sprite for the set font.

If soundASSET is set, it plays a sound per drawn character.

If breakWidth is set, automatically adds new line 
on the first space character it finds after reaching the set break width.

<sup>(Behaves unpredictably with multi-line string literals)</sup>
<br></br>
## .add(string, [talkerName], [talkerSprite])

Adds modified strings to the queue.

Example on how to modify a string:

```gml
Chitter().add("Here is a [color : #0000ff]blue[] color.");
```

This will make the word "blue" draw in a blue color.

You can also use multi-line string literals, and new lines work as they should.

Example using multi-line string literal:
```gml
Chitter().add(@"Here is a [color : #0000ff]blue[] color.
Here is a new line with a [color : #00ff00]green[] color."
);
```
<sub>Mods can not span over multiple lines. Must be per line.</sub>
<br></br>
## .draw(x, y)

Draws the modified string.

```gml
Chitter().draw();
```
Add it to draw GUI event of an object.
<br></br>
## .next()

Trigger to start the queue and send modified string from the queue to be drawn.

Trigger again to skip and view the whole string.

If the whole string is visible trigger again to 

start drawing the next modified string in the

queue, if there is more in the queue.

Returns true if there more in the queue, else false.

```gml
if keyboard_check_pressed(KEY) {
	Chitter().next();
}
```
Add to the step event of an object.
<br></br>
## .talker()

```gml
Chitter().talker();
```
returns string name of the active talker.
<br></br>
## .sprite()

```gml
Chitter().sprite();
``` 
returns the sprite of the active talker, or the sprite added through modifier tags.
<br></br>
## .cleanup()

```gml
Chitter().cleanup();
```
clears the queue, removes all particles, and removes font sprites added at runtime from memory.
<br></br>
## ADDITIONAL INFO

You can also use particles to affect text.

For each unique particles effect you must increase the number or use one not used before.

Example: 

```gml
Chitter().add("[particles : true, part_id : 0, part_scale : true, part_scale_x : 2]Hello[] world!");
```

```gml
Chitter().add("Hello [particles : true, part_id : 1, part_scale : true, part_scale_y : 2]world![]");
```

You can also predefine modifications. Recommended for particles.

Check out Chitter_predefined_mods for examples.

Many of the modifiers also have fade in/out capabilities.

When you want to use the fade in part, set it as: ModifierName_fade_in : 0

This is so it can incrementally go towards 1.

When you want to use the fade out part, set it as: ModifierName_fade_in : 1

This is so it can incrementally go towards 0.
<br></br>  
## MODIFIERS

Comprehensive list of currently available modifier tags and value types:

<br></br>
**LINE BREAK**

line_break : REAL

<br></br>
**ALPHA**

alpha : REAL

<br></br>
alpha_wave : BOOLEAN

alpha_wave_frq : REAL

alpha_wave_amp : REAL

alpha_wave_sep : REAL

alpha_wave_fade_in  : REAL

alpha_wave_fade_out : REAL

alpha_wave_fade_spd : REAL

<br></br>
alpha_flicker : BOOLEAN

alpha_flicker_amount : REAL

alpha_flicker_fade_in  : REAL

alpha_flicker_fade_out : REAL

alpha_flicker_fade_spd : REAL

alpha_flicker_range : BOOLEAN

alpha_flicker_amount_low  : REAL

alpha_flicker_amount_high : REAL

alpha_flicker_range_fade_in  : REAL

alpha_flicker_range_fade_out : REAL

alpha_flicker_range_fade_spd : REAL

<br></br>
**COLOR**

color  : HEX (#000000) OR REAL

color1 : HEX (#000000) OR REAL

color2 : HEX (#000000) OR REAL

color3 : HEX (#000000) OR REAL

color4 : HEX (#000000) OR REAL

<br></br>
**SCALE**

scale   : REAL

scale_x : REAL

scale_y : REAL

<br></br>
**WAVE**

wave_x : BOOLEAN

wave_y : BOOLEAN

wave_frq : REAL

wave_amp : REAL

wave_sep : REAL

wave_fade_in  : REAL

wave_fade_out : REAL

wave_fade_spd : REAL

<br></br>
**PULSATE**

pulsate_x : BOOLEAN

pulsate_y : BOOLEAN

pulsate_frq : REAL

pulsate_amp : REAL

pulsate_sep : REAL

pulsate_fade_in  : REAL

pulsate_fade_out : REAL

pulsate_fade_spd : REAL

<br></br>
**SHAKE**

shake_x : BOOLEAN

shake_y : BOOLEAN

shake_amount : REAL

shake_fade_in  : REAL

shake_fade_out : REAL

shake_fade_spd : REAL

<br></br>
**DISCO**

disco : BOOLEAN

disco_red   : REAL (0 - 255)

disco_green : REAL (0 - 255)

disco_blue  : REAL (0 - 255)

<br></br>
**RAINBOW**

rainbow : BOOLEAN

rainbow_speed : REAL

<br></br>
**TYPEWRITER**

typewriter : BOOL - Default is true.

<br></br>
**WRITE SPEED**

write_speed : REAL

<br></br>
**ROTATION**

rotation : BOOLEAN

rotation_angle : REAL

rotation_speed : REAL

rotation_fade_in  : REAL

rotation_fade_out : REAL

rotation_fade_spd : REAL

<br></br>
rotation_oscillate : BOOLEAN

rotation_oscillate_angle : REAL

rotation_oscillate_frq	 : REAL

rotation_oscillate_amp	 : REAL

rotation_oscillate_sep	 : REAL

rotation_oscillate_fade_in  : REAL

rotation_oscillate_fade_out : REAL

rotation_oscillate_fade_spd : REAL

<br></br>
**DIRECTION**

direction : BOOLEAN

direction_angle : REAL

direction_curve_level : REAL

<br></br>
**SOUND**

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

<br></br>
**TALKER**

talker : STRING

talker_sprite : GMAsset.sprite

<br></br>
**PARTICLES**

particles : BOOLEAN

<br></br>
**PARTICLES - ID**

part_id : REAL - Required for each new effect in an ascending order.

<br></br>
**PARTICLES - FADE IN/OUT**

part_fade_in : NOT YET IMPLEMENTED

part_fade_out : REAL

part_fade_spd : REAL

<br></br>
**PARTICLES - SPRITE**

part_sprite : BOOLEAN

part_sprite_image   : GMAsset.sprite

part_sprite_animate : BOOLEAN

part_sprite_stretch : BOOLEAN

part_sprite_random  : BOOLEAN

<br></br>
**PARTICLES - SIZE**

part_size : BOOLEAN

part_size_min    : REAL

part_size_max    : REAL

part_size_incr   : REAL

part_size_wiggle : BOOLEAN

<br></br>
part_size_x        : BOOLEAN

part_size_x_min    : REAL

part_size_x_max    : REAL

part_size_x_incr   : REAL

part_size_x_wiggle : BOOLEAN


part_size_y        : BOOLEAN

part_size_y_min    : REAL

part_size_y_max    : REAL

part_size_y_incr   : REAL

part_size_y_wiggle : BOOLEAN

<br></br>
**PARTICLES - SCALE**

part_scale : BOOLEAN

part_scale_x : REAL

part_scale_y : REAL

<br></br>
**PARTICLES - SPEED**

part_speed        : BOOLEAN

part_speed_min    : REAL

part_speed_max    : REAL

part_speed_incr   : REAL

part_speed_wiggle : BOOLEAN

<br></br>
**PARTICLES - DIRECTION**

part_direction : BOOLEAN

part_direction_min    : REAL

part_direction_max    : REAL

part_direction_incr   : REAL

part_direction_wiggle : BOOLEAN

<br></br>
**PARTICLES - GRAVITY**

part_gravity : BOOLEAN

part_gravity_amount    : REAL

part_gravity_direction : REAL

<br></br>
**PARTICLES - ORIENTATION**

part_orientation : BOOLEAN

part_orientation_min      : REAL

part_orientation_max      : REAL

part_orientation_incr     : REAL

part_orientation_wiggle   : BOOLEAN

part_orientation_relative : BOOLEAN

<br></br>
**PARTICLES - COLOUR MIX**

part_colour_mix : BOOLEAN

part_colour_mix_1 : HEX (#000000) OR REAL

part_colour_mix_2 : HEX (#000000) OR REAL

<br></br>
**PARTICLES - COLOUR RGB**

part_colour_rgb : BOOLEAN

part_colour_rgb_r_min : REAL (0 - 255)

part_colour_rgb_r_max : REAL (0 - 255)

part_colour_rgb_g_min : REAL (0 - 255)

part_colour_rgb_g_max : REAL (0 - 255)

part_colour_rgb_b_min : REAL (0 - 255)

part_colour_rgb_b_max : REAL (0 - 255)

<br></br>
**PARTICLES - COLOUR HSV**

part_colour_hsv : BOOLEAN

part_colour_hsv_h_min : REAL (0 - 255)

part_colour_hsv_h_max : REAL (0 - 255)

part_colour_hsv_s_min : REAL (0 - 255)

part_colour_hsv_s_max : REAL (0 - 255)

part_colour_hsv_v_min : REAL (0 - 255)

part_colour_hsv_v_max : REAL (0 - 255)

<br></br>
**PARTICLES - COLOUR1**

part_colour1 : HEX (#000000)

<br></br>
**PARTICLES - COLOUR2**

part_colour2 : BOOLEAN

part_colour2_1 : HEX (#000000) OR REAL

part_colour2_2 : HEX (#000000) OR REAL

<br></br>
**PARTICLES - COLOUR3**

part_colour3 : BOOLEAN

part_colour3_1 : HEX (#000000) OR REAL

part_colour3_2 : HEX (#000000) OR REAL

part_colour3_3 : HEX (#000000) OR REAL

<br></br>
**PARTICLES - ALPHA1**

part_alpha1

<br></br>
**PARTICLES - ALPHA2**

part_alpha2 : BOOLEAN

part_alpha2_1 : REAL

part_alpha2_2 : REAL

<br></br>
**PARTICLES - ALPHA3**

part_alpha3 : BOOLEAN

part_alpha3_1 : REAL

part_alpha3_2 : REAL

part_alpha3_3 : REAL

<br></br>
**PARTICLES - BLEND**

part_blend : BOOLEAN

<br></br>
**PARTICLES - LIFE**

part_life : BOOLEAN

part_life_min : REAL

part_life_max : REAL
