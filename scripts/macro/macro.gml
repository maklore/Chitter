#macro SET_TIME var _gtimer = get_timer()
#macro CAL_TIME (get_timer() - _gtimer) / 1000
#macro GET_TIME show_debug_message(string(CAL_TIME) + " ms")

#macro TEST show_debug_message((get_timer() - _gtimer) / 1000"ms")