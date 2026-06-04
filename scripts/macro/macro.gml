#macro SET_TIME var _gtimer = get_timer()
#macro GET_TIME show_debug_message($"{(get_timer() - _gtimer) / 1000}ms")