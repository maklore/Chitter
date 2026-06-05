function tiny_resolution() constructor {
    
    enum GET {
        name,
        width,
        height
    }
    
    enum MON {
        x1 = 4,
        y1 = 5,
        x2 = 6,
        y2 = 7
    }
	
	enum CameraMODE {
		FIXED,
		FOLLOW,
		SPRINGY
	}
	
	enum RES {
		UHD_3840x2160,
		QHD_2560x1440,
		FHD_1920x1080,
		HD_1280x720,
		qHD_960x540,
		SD_640x360,
		D_320x180,
		length
	}

	_res = [
        ["UHD - 3840x2160", 3840, 2160],
        ["QHD - 2560x1440", 2560, 1440],
        ["FHD - 1920x1080", 1920, 1080],
        ["HD - 1280x720",   1280, 720],
        ["qHD - 960x540",   960,  540],
        ["SD - 640x360",    640,  360],
        ["D - 320x180",    320,  180]
    ];
    
    _monitor_data  = undefined;
    _monitor_count = 1;
    _monitor_res   = [];
	
    _monitor_active = 0;
	_monitor_w = 1920;
	_monitor_h = 1080;
    
    _window_x = 0;
    _window_y = 0;
    _window_w = 960;
    _window_h = 540;
	
	_set_res = undefined;
    
	_view_w = 960;
    _view_h = 540;
    _view_p = 0;
    _view_c = view_camera[_view_p];
	
	view_enabled = false;
    view_visible[_view_c] = false;
	display_set_gui_size(_monitor_w, _monitor_h);
	application_surface_enable(false);
	application_surface_draw_enable(false);
	
    _camera_t = undefined;
    _camera_x = 0;
    _camera_y = 0;
    _camera_a = false;
	_camera_m = CameraMODE.FIXED;
	_camera_s = 0.1;

    static system_init = function(_fullscreen) {
        		
        _monitor_data  = window_get_visible_rects(0, 0, 1, 1);
        _monitor_count = array_length(_monitor_data) / 8;
				
        camera_set_view_pos(_view_c, 0, 0);
        camera_set_view_size(_view_c, _view_w, _view_h);
        		
        window_set_fullscreen(_fullscreen);
					
    }
		
    static monitor_set_active = function(_index) {
        
        if _monitor_active == _index { exit; }
        
		var _index_max = clamp(_index, 0, _monitor_count - 1);
		
        _monitor_active = _index_max;
        
        var _fs = window_get_fullscreen();
        
        if _fs == true { window_set_fullscreen(false); }
        
        var _i = _index_max * 8;
        var _x = _monitor_data[MON.x1 + _i];
        var _y = _monitor_data[MON.y1 + _i];
        
        window_set_position(_x, _y);
		
		_monitor_w = display_get_width();
		_monitor_h = display_get_height();
        
        if _fs == true { 
            window_set_fullscreen(true);
			_window_w = _monitor_w;
			_window_h = _monitor_h;
        } else {
            window_center_monitor();
        }
        
    }
	
    static window_center_monitor = function() {
        
        if window_get_fullscreen() == true { exit; }
				
        var _monitor_w_half = _monitor_w * 0.5;
        var _monitor_h_half = _monitor_h * 0.5;
		
        var _window_w_half  = _window_w * 0.5;
        var _window_h_half  = _window_h * 0.5;
		
		var _i = _monitor_active * 8;
        var _x = _monitor_data[MON.x1 + _i];
        var _y = _monitor_data[MON.y1 + _i];
		
        _window_x = _x + _monitor_w_half - _window_w_half;
        _window_y = _y + _monitor_h_half - _window_h_half;
		
        window_set_position(_window_x, _window_y);
    }
    	
	static window_set_windowed = function(_windowed) {
			
		window_set_fullscreen(_windowed);
		
		if _windowed == true {
			window_set_size(_window_w, _window_h);
			window_center_monitor();
		}
	}
    	
    static window_resize = function(_index) {
        
        if window_get_fullscreen() == true { exit; }
        
		self._set_res = _index;
		
        _window_w = _res[_index][GET.width];
        _window_h = _res[_index][GET.height];
        window_set_size(_window_w, _window_h);
        window_center_monitor();
    }
    
	static camera_room_start = function() {
			
		_view_c = view_camera[_view_p];
		
		camera_set_view_size(_view_c, _view_w, _view_h);
		
		if instance_exists(_camera_t) {
			
			x = _camera_t.x - _view_w * 0.5;
			y = _camera_t.y - _view_h * 0.5;
			
			_camera_x = _camera_m != CameraMODE.SPRINGY ? x : 0;
			_camera_y = _camera_m != CameraMODE.SPRINGY ? y : 0;
			
			camera_set_view_pos(_view_c, x, y);
		}
		
		camera_visible(true);
	}
	
	static camera_resize = function(_index) {
		
		_view_w = _res[_index][GET.width];
        _view_h = _res[_index][GET.height];
		camera_set_view_size(_view_c, _view_w, _view_h);
	}
	
    static camera_visible = function(_active) {
        		
        _camera_a = _active;
        view_enabled = _active;
        view_visible[_view_c] = _active;		
		
    }
    
	static camera_angle = function(_angle) {
		camera_set_view_angle(_view_c, _angle);
	}
	
    static camera_target = function(_instance) {
        
        _camera_t = _instance;
		
		if instance_exists(_camera_t) {
			camera_set_view_pos(_view_c, _camera_t.x - _view_w * 0.5, _camera_t.y - _view_h * 0.5);
		}
	}
    
	static camera_mode = function(_mode, _speed = 0.1) {
				
		_camera_m = _mode;
		_camera_s = _speed;
	}
	
    static camera_update = function() {

        if !_camera_a or !instance_exists(_camera_t) { exit; }
		
		var _target_x = _camera_t.x - _view_w * 0.5;
		var _target_y = _camera_t.y - _view_h * 0.5;
		
		switch _camera_m {
			
			case CameraMODE.FIXED :
				
		        camera_set_view_pos(_view_c, _target_x, _target_y);
				
			break;
			
			case CameraMODE.FOLLOW :
			
		        _camera_x += (_target_x - _camera_x) * _camera_s;
		        _camera_y += (_target_y - _camera_y) * _camera_s;
				
		        camera_set_view_pos(_view_c, _camera_x, _camera_y);
				
			break;
			
			case CameraMODE.SPRINGY :
			
				_camera_x = lerp(_camera_x, (_target_x - x) * _camera_s, _camera_s);
				_camera_y = lerp(_camera_y, (_target_y - y) * _camera_s, _camera_s);
				
				x += (_camera_x);
				y += (_camera_y);
				
				camera_set_view_pos(_view_c, x, y);
				
			break;
		}
    }

}

#macro RESOLUTION global.resolution
RESOLUTION = new tiny_resolution();
