
function Animation(_start_frame, _end_frame, _speed) constructor {
    start_frame = _start_frame;
    end_frame = _end_frame;
    current_frame = _start_frame;
    speed = _speed;
}

function AnimationManager(_instance) constructor {
    instance = _instance;
    animations = ds_map_create();
    current_animation = undefined;
    
    add_animation = function(_animation_name, _animation) {
        ds_map_add(animations, _animation_name, _animation);
        if (ds_map_size(animations) <= 1) {
            current_animation = _animation;
        }
    }
    
    get_animation = function(_animation_name) {
        return ds_map_find_value(animations, _animation_name);
    }
    
    play_animation = function(_animation_name) {
        current_animation = get_animation(_animation_name);
        
        current_animation.current_frame += current_animation.speed;
        if (current_animation.current_frame >= current_animation.end_frame) {
            current_animation.current_frame = current_animation.start_frame;
        }
        instance.image_index = current_animation.current_frame;
    }
    
    stop_animation = function() {
        instance.image_index = current_animation.start_frame;
    }
    
    get_current_animation_name = function() {
        var _animation_manager_keys = ds_map_keys_to_array(animations);
        for (var _i = 0; _i < array_length(_animation_manager_keys); _i++) {
            if (get_animation(_animation_manager_keys[_i]).start_frame == current_animation.start_frame) {
                return _animation_manager_keys[_i];
            }
        }
    }
}
