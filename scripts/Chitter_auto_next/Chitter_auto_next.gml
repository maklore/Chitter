/**
@desc Automatically goes to next text in queue. 
*
Can be called with the modifier tag 'script' and queue ID set with 'script_arg1'. 
*
@param {string} _id Queue ID.
*/

function chitter_auto_next(_id){

	chitter().__auto_next($"{_id}");
}