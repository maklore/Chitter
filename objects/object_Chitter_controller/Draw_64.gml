var _x = display_get_gui_width() * 0.01;
var _y = display_get_gui_height() * 0.55;

chitter().draw(_x, _y);

var _speaker_name = chitter().get_active_speaker_name();
var _speaker_sprite = chitter().get_active_speaker_sprite();

if _speaker_name != 0 {
	draw_set_font(font_example_2)
	draw_text(_x, 96, _speaker_name);
	if _speaker_sprite != undefined {
		draw_sprite(_speaker_sprite, 0, _x, 196);
	}
}