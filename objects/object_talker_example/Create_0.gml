chitter()

.add("0", "Maklore", 
@"Hi and welcome to [part_id : 0, PART_light_rainbow_mush]Chitter[]![wait_seconds : 1.5] []
Please do read the wiki at Github!

Usually you have to trigger .next(ID) 
in some way (pressing 'E' for now).[wait_seconds : 1] []
I have set it up so once you 
press 'E' the next example will 
autoplay the dialogue for you.
[wave]Enjoy![]")

.add("0", "Maklore", 
$"So, [wave]what's up?[][wait_seconds : 2] []Need [write_speed : 24]anything?[][wait_seconds : 2] [][next_id : 0] []", spr_maklore)

.add("0","Indrome",
@"No..[wait_seconds : 2] []
It's just a bit [SDF_fuzzy_text, part_id : 0, part_draw_text, PART_freezing]cold..[][wait_seconds : 2] [][next_id : 0] []", spr_indrome)

.add("0", "Germ", 
@"[part_id : 0, PART_burn_to_char]IT'S SCORCHING HERE!![][wait_seconds : 2] []
[write_speed : 120]What do you mean by it's cold?[][wait_seconds : 2] [][next_id : 0] []", spr_germ)

.add("0", "Blovarsk", 
"We created the [part_id : 0, PART_burn_static]heat[] and [part_id : 1, PART_freezing]cold[] you know..[wait_seconds : 2] [] [next_id : 0] []", spr_blovarsk)

.add("0", "TabularElf", 
"Have you [part_id : 0, PART_enraged]been[] down under?[wait_seconds : 2] [][next_id : 0] []", spr_tabularelf)

.add("0", "instructioninstruction", 
"...", spr_instructioninstruction)

chitter().next("0");