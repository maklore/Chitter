	//static next = function(_id) {
		
	//	if !struct_exists(__chitter_queue, _id) {
	//		show_debug_message($"Invalid ID : {_id}");
	//		exit;
	//	}

	//	var __queue = __chitter_queue[$ _id];

	//	//If position is equal to length, and queue is empty return false.
	//	if __write_pos >= __string_length and ds_list_size(__queue.__string_list) == 0 {
	//		exit;
	//	}
		
	//	//If position is less than length, draw the rest.
	//	if __write_pos < __string_length {
	//		__write_pos = __string_length;
			
	//		__text_skip_typewriter();
			
	//		exit;
	//	}
		
	//	__next = true;
		
	//	__write_pos = 0;
	//	__string_pos = 0;
	//	__floor_pos = 0;
	//	__string_draw = "";	
		
	//	//Fetch oldest data from queue.
	//	__string_length = string_length(__queue.__string_list[| 0]);
	//	__string_current = __queue.__string_list[| 0];
		
		
	//	if ds_list_size(__queue.__mod_list) > 0 {
			
	//		//Get particle type id count, destroy them before next string gets added.
	//		var _part_list_size = ds_list_size(__part_id);
			
	//		var _i = 0;
			
	//		repeat _part_list_size {
			
	//			if part_type_exists(__part_id[| _i]) {
	//				part_type_destroy(__part_id[| _i]);
	//			}
	//			_i++;
			
	//		}	
			

	//		__text_gridify(__queue.__talker[| 0], __queue.__sprite[| 0], __string_current);
	//		__text_modify(__queue.__mod_list[| 0], __grid);
			
	//		//Delete oldest data from queue.
	//		ds_list_delete(__queue.__mod_list, 0);
	//		ds_list_delete(__queue.__string_list, 0);
	//		ds_list_delete(__queue.__talker, 0);
	//		ds_list_delete(__queue.__sprite, 0);
	//	}
	//};
	
	
		//static add = function(_id, _name, _string, _sprite = undefined) {
		
	//	if !struct_exists(__chitter_queue, _id) {
	//		__chitter_queue[$ _id] = {
	//			__talker : ds_list_create(),
	//			__sprite : ds_list_create(),
	//			__string_list : ds_list_create(),
	//			__mod_list : ds_list_create()
	//		}
	//	}
		
	//	var _text_list = __text_parse(_string);
		
	//	ds_list_add(__chitter_queue[$ _id].__talker, _name);
	//	ds_list_add(__chitter_queue[$ _id].__sprite, _sprite);
	//	ds_list_add(__chitter_queue[$ _id].__string_list, __text_clean(__string_current, _text_list));
	//	ds_list_add(__chitter_queue[$ _id].__mod_list, __text_list_clean(_text_list));
				
	//	return self;
	//}