/// @ignore
function __hex_to_colour(_string) {

	static _struct_hex = {
	    "0" : 0,
	    "1" : 1,
	    "2" : 2,
	    "3" : 3,
	    "4" : 4,
	    "5" : 5,
	    "6" : 6,
	    "7" : 7,
	    "8" : 8,
	    "9" : 9,
	    "A" : 10,
	    "B" : 11,
	    "C" : 12,
	    "D" : 13,
	    "E" : 14,
	    "F" : 15
	}
		
	static _ddig = 16;
	static _base = 256;
	static _max_r = _base;
	static _max_g = _max_r * _base;
	static _max_b = _max_g * _base;
		
	var _string_upper = string_upper(string_delete(_string, 1, 1));

	var _R1 = _max_r / _base * struct_get(_struct_hex, string_char_at(_string_upper, 2));
	var _R2 = _max_r / _ddig * struct_get(_struct_hex, string_char_at(_string_upper, 1));
	var _G1 = _max_g / _base * struct_get(_struct_hex, string_char_at(_string_upper, 4));
	var _G2 = _max_g / _ddig * struct_get(_struct_hex, string_char_at(_string_upper, 3));
	var _B1 = _max_b / _base * struct_get(_struct_hex, string_char_at(_string_upper, 6));
	var _B2 = _max_b / _ddig * struct_get(_struct_hex, string_char_at(_string_upper, 5));

	return (_R1 + _R2 + _G1 + _G2 + _B1 + _B2);
}
	