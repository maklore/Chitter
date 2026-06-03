/// @ignore
function __font_to_spr(_font, _range_min, _range_max) { 

	draw_set_halign(fa_left);	
	draw_set_valign(fa_bottom);
		
	draw_set_font(_font);
	    
	var _size = font_get_size(_font) * 2;
	var _ind = _range_min;
	var _len = _range_max - _range_min;
	var _surf_wh = _size;
	var _draw_w = 0;
	var _draw_h = _size;
	var _spr_return = undefined;
	var _surf = surface_create(_surf_wh, _surf_wh);
    
	if surface_exists(_surf) {
	    _spr_return = sprite_create_from_surface(_surf, 0, 0, _size, _size, true, false, _draw_w, _draw_h); 
	    surface_set_target(_surf);
	    repeat (_len) {
	        draw_clear_alpha(c_black, 0);
	        draw_text(_draw_w, _draw_h, chr(_ind));
	        sprite_add_from_surface(_spr_return, _surf, 0, 0, _size, _size, false, false);
	        _ind++;
	    }
	    surface_reset_target();
	    surface_free(_surf);
	}
		
	return _spr_return;
}