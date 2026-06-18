/**
@desc Replaces the whole drawn string with a new string to be redrawn. 
*
Can be called with the modifier tag 'script' and new string set with 'script_arg1'. 
*
@param {string} _string New string.
@param {bool} _typewriter Enabled by default.
*/
function chitter_text_replace(_string, _typewriter = true) {
	
	chitter().__text_replace(_string, _typewriter);
}