<sub>(  WORK IN PROGRESS  )</sub>

# Welcome to Chitter!

This is a text altering system that adds modified strings to a queue.

> Works only with monospace font for now.
<br></br>
### Example effects:

![](https://github.com/maklore/Chitter/blob/main/gifs/weird.gif)

![](https://github.com/maklore/Chitter/blob/main/gifs/rainbow.gif)

![](https://github.com/maklore/Chitter/blob/main/gifs/burn.gif)

![](https://github.com/maklore/Chitter/blob/main/gifs/insanity.gif)


## .initialise(fontASSET, [soundASSET], [breakWidth])

```gml
Chitter().initialise(fontASSET);
```

Initialises Chitter.

The system creates sprites for each font asset.

| ARGUMENT | TYPE | DESCRIPTION |
|-|-|-|
| `fontASSET` | Asset.GMFont | Base font to be drawn |
| `[soundASSET]` | Asset.GMSound | Plays set sound per drawn character |
| `[breakWidth]` | REAL | Adds new line on the first space character it finds after reaching break width. |

> Do not use `breakWidth` with multi-line string literals. (Unpredictable outcomes)

## .add(string, [talkerName], [talkerSprite])

Adds modified strings to the queue.

| ARGUMENT | TYPE | DESCRIPTION |
|-|-|-|
| `string`| String | Modified string |
| `[talkerName]` | String | String name of current talker |
| `[talkerSprite]` | Asset.GMSprite | Sprite asset of current talker |


**Examples:**

The substring "blue" will draw in a blue colour.

```gml
Chitter().add("Here is a [colour : #0000ff]blue[] colour.");
```

You can also use multi-line string literals.

```gml
Chitter().add(@"Here is a [colour : #0000ff]blue[] colour.
Here is a new line with a [colour : #00ff00]green[] colour.");
```
> Modifiers can not span over multiple lines. Must be per line.

## .talker()

```gml
Chitter().talker();
```
Returns current active talker name set in `.add()` or added through modifier tags.

## .sprite()

```gml
Chitter().sprite();
``` 
Returns current active talker sprite set in `.add()` or added through modifier tags.

## .next()

```gml
Chitter().next();
```

Sends the modified string from the queue to be drawn.

>While the modified string is being drawn, calling this again will auto skip the drawing and display the whole string modified.
>
>If the whole string is displayed, calling it again will send the next (if there is one) modified string to be drawn.


Example to call function:

```gml
if keyboard_check_pressed(vk_space) {
	Chitter().next();
}
```
> Recommend adding it to a triggered event of an object.

## .draw(x, y)

```gml
Chitter().draw();
```

Draw the modified string.

| ARGUMENT | TYPE | DESCRIPTION |
|-|-|-|
| `x`| REAL | X position of modified string to be drawn |
| `y` | REAL | Y position of modified string to be drawn |

> Recommend adding it to the draw GUI event of an object.

## .cleanup()

```gml
Chitter().cleanup();
```
Clears the queue, removes all particles, and removes font sprites added at runtime from memory.

<br> </br>
## USEFUL INFORMATION

**Particles and SDF Font effects are also integrated into the modifier tag system.**

Particles example: 

```gml
Chitter().add("Hello [particles : true, part_id : 0, part_colour1 : #ff0000]world![]");
```

For each ***unique*** particles effect you must increase the part_id ***index*** in an ***ascending*** order.

```gml
Chitter().add("[particles : true, part_id : 0, part_colour1 : #ff0000]Hello[] [particles : true, part_id : 1, part_colour1 : #00ff00]world![]");
```

SDF Font effects example:

```gml
Chitter().add("[sdf : true, sdf_outline : true, sdf_outline_distance : 3, sdf_outline_colour : #ffffff]Hello World![]");
```

> If you want to change the colour of the main font body when using SDF,
>
> include the tag `colour : #ffffff`, and then use `sdf_core_colour` to change the colour.
>
> Since SDF colours multiplies with the existing colour,
>
> it can behave in unintended ways if the base colour is not set to white.

You can also predefine modification tags in **Chitter_predefined_mods** script file.

Adding the string variable in the `Example 1` below to the constructor function, makes it so you

can instead of writing the all of the tags in the string you can just use the variable name
seen in `Example 2`.

> Example 1:
```gml
sdf_white_outline = "sdf : true, sdf_outline : true, sdf_outline_distance : 3, sdf_outline_colour : #ffffff"
```
> Example 2:
```gml
Chitter().add("[sdf_white_outline]Hello World![]");
```


<br></br>  
## MODIFIERS

**Comprehensive list of currently available modifier tags and value types:**

<details>
<summary>LINE BREAK - Not needed when using multi-line string literals.</summary>
	
| TAG | TYPE |
|-|-|
| line_break | BOOL |
	
</details>

<details>
<summary>ALPHA</summary>

| TAG | TYPE |
|-|-|
| alpha | REAL |
| |
| alpha_wave | BOOL |
| alpha_wave_frq | REAL |
| alpha_wave_amp | REAL |
| alpha_wave_sep | REAL |
| alpha_wave_fade_in  | BOOL |
| alpha_wave_fade_out | BOOL |
| alpha_wave_fade_frames | REAL |
| |
| alpha_random | BOOL |
| alpha_random_amount | REAL |
| alpha_random_fade_in | BOOL |
| alpha_random_fade_out | BOOL |
| alpha_random_fade_frames | REAL |
| |
| alpha_random_range | BOOL |
| alpha_random_amount_low  | REAL |
| alpha_random_amount_high | REAL |
| alpha_random_range_fade_in | BOOL |
| alpha_random_range_fade_out | BOOL |
| alpha_random_range_fade_frames | REAL |

</details>

<details>
<summary>COLOUR</summary>
	
| TAG | TYPE |
|-|-|
| colour  | HEX OR REAL - Sets for all four colours | 
| colour1 | HEX OR REAL |
| colour2 | HEX OR REAL |
| colour3 | HEX OR REAL |
| colour4 | HEX OR REAL |

</details>

<details>
<summary>COLOUR RANDOM</summary>
  
| TAG | TYPE | RANGE |
|-|-|-|
| colour_random | BOOL |
| colour_random_red   | REAL | (0 - 255) |
| colour_random_green | REAL | (0 - 255) |
| colour_random_blue  | REAL | (0 - 255) |
| colour_random_fade_in | BOOL |
| colour_random_fade_out | BOOL |
| colour_random_fade_frames | REAL |

</details>

<details>
<summary>SCALE</summary>
  
| TAG | TYPE |
|-|-|
| scale   | REAL |
| scale_x | REAL |
| scale_y | REAL |

</details>

<details>
<summary>WAVE</summary>
  
| TAG | TYPE |
|-|-|
| wave_x | BOOL |
| wave_y | BOOL |
| wave_frq | REAL |
| wave_amp | REAL |
| wave_sep | REAL |
| wave_fade_in  | BOOL |
| wave_fade_out | BOOL |
| wave_fade_frames | REAL |

</details>

<details>
<summary>PULSATE</summary>
  
| TAG | TYPE |
|-|-|
| pulsate_x | BOOL |
| pulsate_y | BOOL |
| pulsate_frq | REAL |
| pulsate_amp | REAL |
| pulsate_sep | REAL |
| pulsate_fade_in  | BOOL |
| pulsate_fade_out | BOOL |
| pulsate_fade_frames | REAL |

</details>

<details>
<summary>SHAKE</summary>
  
| TAG | TYPE |
|-|-|
| shake_x | BOOL |
| shake_y | BOOL |
| shake_amount | REAL |
| shake_fade_in  | BOOL |
| shake_fade_out | BOOL |
| shake_fade_frames | REAL |

</details>

<details>
<summary>RAINBOW</summary>
  
| TAG | TYPE |
|-|-|
| rainbow | BOOL |
| rainbow_speed | REAL |
| rainbow_fade_in | BOOL |
| rainbow_fade_out | BOOL |
| rainbow_fade_frames | REAL |

</details>

<details>
<summary>TYPEWRITER</summary>
  
| TAG | TYPE |
|-|-|
| typewriter | BOOL - Default is true. |

</details>

<details>
<summary>WRITE SPEED</summary>
  
| TAG | TYPE |
|-|-|
| write_speed | REAL |

</details>

<details>
<summary>ROTATION</summary>
  
| TAG | TYPE |
|-|-|
| rotation | BOOL |
| rotation_angle | REAL |
| rotation_speed | REAL |
| rotation_fade_in  | BOOL |
| rotation_fade_out | BOOL |
| rotation_fade_frames | REAL |
| |
| rotation_oscillate | BOOL |
| rotation_oscillate_angle | REAL |
| rotation_oscillate_frq | REAL |
| rotation_oscillate_amp | REAL |
| rotation_oscillate_sep | REAL |
| rotation_oscillate_fade_in  | BOOL |
| rotation_oscillate_fade_out | BOOL |
| rotation_oscillate_fade_frames | REAL |

</details>

<details>
<summary>DIRECTION</summary>
  
| TAG | TYPE |
|-|-|
| direction | BOOL |
| direction_angle | REAL |
| direction_curve_level | REAL |

</details>

<details>
<summary>SDF EFFECTS</summary>
  
| TAG | TYPE | RANGE |
|-|-|-|
| sdf | BOOL |
| sdf_thickness | REAL |
| |
| sdf_core_colour | HEX OR REAL |
| sdf_core_colour_random | BOOL |
| sdf_core_colour_random_red | REAL | (0 - 255) |
| sdf_core_colour_random_green | REAL | (0 - 255) |
| sdf_core_colour_random_blue | REAL | (0 - 255) |
| |
| sdf_core_alpha | REAL |
| sdf_core_rainbow | BOOL |
| sdf_core_rainbow_speed | REAL |
| |
| sdf_outline | BOOL |
| sdf_outline_distance | REAL |
| |
| sdf_outline_colour | HEX OR REAL |
| sdf_outline_colour_random | BOOL |
| sdf_outline_colour_random_red | REAL | (0 - 255) |
| sdf_outline_colour_random_green | REAL | (0 - 255) |
| sdf_outline_colour_random_blue | REAL | (0 - 255) |
| |
| sdf_outline_alpha | REAL |
| sdf_outline_rainbow | BOOL |
| sdf_outline_rainbow_speed | REAL |
| |
| sdf_glow | BOOL |
| sdf_glow_start | REAL |
| sdf_glow_end | REAL |
| |
| sdf_glow_colour | HEX OR REAL |
| sdf_glow_colour_random | BOOL |
| sdf_glow_colour_random_red | REAL | (0 - 255) |
| sdf_glow_colour_random_green | REAL | (0 - 255) |
| sdf_glow_colour_random_blue | REAL | (0 - 255) |
| |
| sdf_glow_alpha | REAL |
| sdf_glow_rainbow | BOOL |
| sdf_glow_rainbow_speed | REAL |
| |
| sdf_shadow | BOOL |
| sdf_shadow_softness | REAL |
| sdf_shadow_offset_x | REAL |
| sdf_shadow_offset_y | REAL |
| |
| sdf_shadow_colour | HEX OR REAL |
| sdf_shadow_colour_random | BOOL |
| sdf_shadow_colour_random_red | REAL | (0 - 255) |
| sdf_shadow_colour_random_green | REAL | (0 - 255) |
| sdf_shadow_colour_random_blue | REAL | (0 - 255) |
| |
| sdf_shadow_alpha | REAL |
| sdf_shadow_rainbow | BOOL |
| sdf_shadow_rainbow_speed | REAL |

</details>

<details>
<summary>SOUND</summary>
  
| TAG | TYPE |
|-|-|
| sound_index         | GMAsset.sound |
| sound_priority      | REAL |
| sound_loop          | BOOL |
| |
| sound_gain          | REAL |
| sound_gain_low      | REAL |
| sound_gain_high     | REAL |
| sound_gain_random   | BOOL |
| | |
| sound_offset        | REAL |
| sound_offset_low    | REAL |
| sound_offset_high   | REAL |
| sound_offset_random | BOOL |
| | |
| sound_pitch         | REAL |
| sound_pitch_low     | REAL |
| sound_pitch_high    | REAL |
| sound_pitch_random  | BOOL |

</details>

<details>
<summary>TALKER</summary>
  
| TAG | TYPE |
|-|-|
| talker | STRING |
| talker_sprite | GMAsset.sprite |

</details>

<details>
<summary>PARTICLES</summary>
  
| TAG | TYPE |
|-|-|
| particles | BOOL |

</details>

<details>
<summary>PARTICLES - ID - New ID required per unique collection of particle effects in an ascending order.</summary>
  
| TAG | TYPE |
|-|-|
| part_id | REAL |

</details>

<details>
<summary>PARTICLES - FADE IN/OUT</summary>
  
| TAG | TYPE |
|-|-|
| part_fade_in | NOT YET IMPLEMENTED |
| part_fade_out | BOOL |
| part_fade_frames | REAL |

</details>

<details>
<summary>PARTICLES - SPRITE</summary>
  
| TAG | TYPE |
|-|-|
| part_sprite | BOOL |
| part_sprite_image   | GMAsset.sprite |
| part_sprite_animate | BOOL |
| part_sprite_stretch | BOOL |
| part_sprite_random  | BOOL |

</details>

<details>
<summary>PARTICLES - SIZE</summary>
  
| TAG | TYPE |
|-|-|
| part_size | BOOL |
| part_size_min    | REAL |
| part_size_max    | REAL |
| part_size_incr   | REAL |
| part_size_wiggle | BOOL |
| |
| part_size_x        | BOOL |
| part_size_x_min    | REAL |
| part_size_x_max    | REAL |
| part_size_x_incr   | REAL |
| part_size_x_wiggle | BOOL |
| |
| part_size_y        | BOOL |
| part_size_y_min    | REAL |
| part_size_y_max    | REAL |
| part_size_y_incr   | REAL |
| part_size_y_wiggle | BOOL |

</details>

<details>
<summary>PARTICLES - SCALE</summary>
  
| TAG | TYPE |
|-|-|
| part_scale | BOOL |
| part_scale_x | REAL |
| part_scale_y | REAL |

</details>

<details>
<summary>PARTICLES - SPEED</summary>
  
| TAG | TYPE |
|-|-|
| part_speed        | BOOL |
| part_speed_min    | REAL |
| part_speed_max    | REAL |
| part_speed_incr   | REAL |
| part_speed_wiggle | BOOL |

</details>

<details>
<summary>PARTICLES - DIRECTION</summary>
  
| TAG | TYPE |
|-|-|
| part_direction | BOOL |
| part_direction_min    | REAL |
| part_direction_max    | REAL |
| part_direction_incr   | REAL |
| part_direction_wiggle | BOOL |

</details>

<details>
<summary>PARTICLES - GRAVITY</summary>
  
| TAG | TYPE |
|-|-|
| part_gravity | BOOL |
| part_gravity_amount    | REAL |
| part_gravity_direction | REAL |

</details>

<details>
<summary>PARTICLES - ORIENTATION</summary>
  
| TAG | TYPE |
|-|-|
| part_orientation | BOOL |
| part_orientation_min      | REAL |
| part_orientation_max      | REAL |
| part_orientation_incr     | REAL |
| part_orientation_wiggle   | BOOL |
| part_orientation_relative | BOOL |

</details>

<details>
<summary>PARTICLES - COLOUR MIX</summary>
  
| TAG | TYPE |
|-|-|
| part_colour_mix | BOOL |
| part_colour_mix_1 | HEX OR REAL |
| part_colour_mix_2 | HEX OR REAL |

</details>

<details>
<summary>PARTICLES - COLOUR RGB</summary>
  
| TAG | TYPE | RANGE |
|-|-|-|
| part_colour_rgb | BOOL
| part_colour_rgb_r_min | REAL | (0 - 255) |
| part_colour_rgb_r_max | REAL | (0 - 255) |
| part_colour_rgb_g_min | REAL | (0 - 255) |
| part_colour_rgb_g_max | REAL | (0 - 255) |
| part_colour_rgb_b_min | REAL | (0 - 255) |
| part_colour_rgb_b_max | REAL | (0 - 255) |

</details>

<details>
<summary>PARTICLES - COLOUR HSV</summary>
  
| TAG | TYPE | RANGE |
|-|-|-|
| part_colour_hsv | BOOL
| part_colour_hsv_h_min | REAL | (0 - 255) |
| part_colour_hsv_h_max | REAL | (0 - 255) |
| part_colour_hsv_s_min | REAL | (0 - 255) |
| part_colour_hsv_s_max | REAL | (0 - 255) |
| part_colour_hsv_v_min | REAL | (0 - 255) |
| part_colour_hsv_v_max | REAL | (0 - 255) |

</details>

<details>
<summary>PARTICLES - COLOUR1</summary>
  
| TAG | TYPE |
|-|-|
| part_colour1 | HEX OR REAL |

</details>

<details>
<summary>PARTICLES - COLOUR2</summary>
  
| TAG | TYPE |
|-|-|
| part_colour2 | BOOL |
| part_colour2_1 | HEX  OR REAL |
| part_colour2_2 | HEX OR REAL |

</details>

<details>
<summary>PARTICLES - COLOUR3</summary>
  
| TAG | TYPE |
|-|-|
| part_colour3 | BOOL |
| part_colour3_1 | HEX OR REAL |
| part_colour3_2 | HEX OR REAL |
| part_colour3_3 | HEX OR REAL |

</details>

<details>
<summary>PARTICLES - COLOUR RAINBOW</summary>
  
| TAG | TYPE |
|-|-|
| part_colour_rainbow | BOOL |
| part_colour_rainbow_speed | REAL |

</details>

<details>
<summary>PARTICLES - COLOUR RANDOM</summary>
  
| TAG | TYPE | RANGE |
|-|-|-|
| part_colour_random | BOOL | (0-255) |
| part_colour_random_red | REAL | (0-255) |
| part_colour_random_green | REAL | (0-255) |
| part_colour_random_blue | REAL | (0-255) |

</details>

<details>
<summary>PARTICLES - ALPHA1</summary>
  
| TAG | TYPE |
|-|-|
| part_alpha1 | REAL |

</details>

<details>
<summary>PARTICLES - ALPHA2</summary>
  
| TAG | TYPE |
|-|-|
| part_alpha2 | BOOL |
| part_alpha2_1 | REAL |
| part_alpha2_2 | REAL |

</details>

<details>
<summary>PARTICLES - ALPHA3</summary>
  
| TAG | TYPE |
|-|-|
| part_alpha3 | BOOL |
| part_alpha3_1 | REAL |
| part_alpha3_2 | REAL |
| part_alpha3_3 | REAL |

</details>

<details>
<summary>PARTICLES - BLEND</summary>
  
| TAG | TYPE |
|-|-|
| part_blend | BOOL |

</details>

<details>
<summary>PARTICLES - LIFE</summary>
  
| TAG | TYPE |
|-|-|
| part_life | BOOL |
| part_life_min | REAL |
| part_life_max | REAL |

</details>
