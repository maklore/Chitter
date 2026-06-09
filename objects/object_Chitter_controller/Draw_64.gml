var _x = display_get_gui_width() * 0.02;
var _y = display_get_gui_height() * 0.65;

Chitter().draw(_x, _y);

var _talker = Chitter().talker();

if _talker != 0 {
	draw_text(_x, _y - 200, _talker);	
}