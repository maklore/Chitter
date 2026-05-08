var _x1 = display_get_gui_width() * 0.02;
var _y1 = display_get_gui_height() * 0.15;

Chitter().draw(_x1, _y1);

var _size = Chitter().text_size();

var _pad = _padding * (_size[0] > 0);

_x2 = lerp(_x2, _x1 + _size[0] + _pad, 0.5);
_y2 = lerp(_y2, _y1 + _size[1] - _pad, 0.5);

draw_rectangle(_x1 - _padding, _y1 - _pad * 2, _x2, _y2, true);
//draw_rectangle(_x1 - _padding, _y1 - _pad * 2, _x1 + _size[2] + _pad, _y1 + _size[3] - _pad, true);

