/**
 Chitter() is a system that adds modified string to a queue system and draws it.
 *
 List of function key accessors:
 *
 .initialise(), .add(), .next(), .talker(), .sprite(), .sound(), .cleanup(), .draw()
 */
 
function Chitter() {
	static __chit = new __chitter();
	return 	__chit;
}