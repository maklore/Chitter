#macro SET_TIME var _time = get_timer()
#macro GET_TIME show_debug_message($"{(get_timer() - _time) / 1000}ms")