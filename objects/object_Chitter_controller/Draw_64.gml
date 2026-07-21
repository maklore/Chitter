var _x = display_get_gui_width() * 0.2;
var _y = display_get_gui_height() * 0.65;

chitter().draw(_x, _y);

var _talker = chitter().talker();

if _talker != 0 {
	draw_set_font(font_example_2)
	draw_text(_x, 96, _talker);	
}