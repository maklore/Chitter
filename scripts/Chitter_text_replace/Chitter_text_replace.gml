/**
@desc Replaces the whole drawn string with a new string to be redrawn. Can be called with the modifier tag 'script' and new string set with 'script_arg1'. 
*
@param {any*} _string New string.
*/
function chitter_text_replace(_string){
	chitter().__text_replace(_string);
}