var _x1 = display_get_gui_width() * 0.02;
var _y1 = display_get_gui_height() * 0.15;

Chitter().draw(_x1, _y1);

draw_set_font(font_example_1)
draw_set_valign(fa_top)
draw_set_halign(fa_left)
draw_text(0, 0, fps_real)

