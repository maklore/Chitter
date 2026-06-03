/// @ignore
function __text_clean(_string, _list) {
	var _string_new = _string;
	var _ds_length = ds_list_size(_list);
		
	for (var i = _ds_length - 1; i >= 0; --i;) {
		_string_new = string_delete(_string_new, _list[| i].start + 1, _list[| i].length);
	}
	return _string_new;
}