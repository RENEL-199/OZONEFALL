function vegetation_sway_initialize()
{
    var _supported =
        shaders_are_supported();

    var _compiled = false;

    if (_supported)
    {
        _compiled =
            shader_is_compiled(
                shd_vegetation_sway
            );
    }

    var _uniform_sway = -1;
    var _uniform_instance = -1;
    var _uniform_flash = -1;

    if (_compiled)
    {
        _uniform_sway =
            shader_get_uniform(
                shd_vegetation_sway,
                "u_sway_data"
            );

        _uniform_instance =
            shader_get_uniform(
                shd_vegetation_sway,
                "u_instance_data"
            );

        _uniform_flash =
            shader_get_uniform(
                shd_vegetation_sway,
                "u_flash"
            );
    }

    global.vegetation_sway =
    {
        enabled:
            _supported &&
            _compiled,

        wind_strength: 1,
        wind_speed: 1,

        uniform_sway:
            _uniform_sway,

        uniform_instance:
            _uniform_instance,

        uniform_flash:
            _uniform_flash
    };

    return global.vegetation_sway.enabled;
}

function vegetation_sway_is_visible(
    _instance,
    _margin = 48
)
{
    var _camera =
        view_camera[0];

    if (_camera == -1)
    {
        return true;
    }

    var _camera_left =
        camera_get_view_x(
            _camera
        ) -
        _margin;

    var _camera_top =
        camera_get_view_y(
            _camera
        ) -
        _margin;

    var _camera_right =
        _camera_left +
        camera_get_view_width(
            _camera
        ) +
        _margin * 2;

    var _camera_bottom =
        _camera_top +
        camera_get_view_height(
            _camera
        ) +
        _margin * 2;

    return !(
        _instance.bbox_right <
        _camera_left ||

        _instance.bbox_left >
        _camera_right ||

        _instance.bbox_bottom <
        _camera_top ||

        _instance.bbox_top >
        _camera_bottom
    );
}


function vegetation_sway_draw(
    _instance,
    _strength = 1,
    _speed = 1,
    _flash_amount = 0,
    _shake_x = 0
)
{
    if (!instance_exists(_instance))
    {
        return false;
    }

    if (
        !sprite_exists(
            _instance.sprite_index
        )
    )
    {
        return false;
    }

    if (
        !vegetation_sway_is_visible(
            _instance
        )
    )
    {
        return false;
    }

    if (
        !variable_global_exists(
            "vegetation_sway"
        )
    )
    {
        vegetation_sway_initialize();
    }

    var _settings =
        global.vegetation_sway;

    var _draw_x =
        _instance.x +
        _shake_x;

    if (!_settings.enabled)
    {
        draw_sprite_ext(
            _instance.sprite_index,
            _instance.image_index,
            _draw_x,
            _instance.y,
            _instance.image_xscale,
            _instance.image_yscale,
            _instance.image_angle,
            _instance.image_blend,
            _instance.image_alpha
        );

        return true;
    }

    var _sprite_height =
        sprite_get_height(
            _instance.sprite_index
        );

    var _sprite_origin_y =
        sprite_get_yoffset(
            _instance.sprite_index
        );

    var _sprite_top =
        _instance.y -
        _sprite_origin_y *
        _instance.image_yscale;

    var _sprite_bottom =
        _sprite_top +
        _sprite_height *
        _instance.image_yscale;

    if (_sprite_bottom < _sprite_top)
    {
        var _swap =
            _sprite_top;

        _sprite_top =
            _sprite_bottom;

        _sprite_bottom =
            _swap;
    }

    var _position_hash =
        abs(
            sin(
                _instance.x *
                0.017 +
                _instance.y *
                0.013
            ) *
            43758.5453
        );

    var _phase =
        (
            _position_hash -
            floor(_position_hash)
        ) *
        6.283185;

    var _time =
        current_time /
        1000;

   var _strength_hash =
    abs(
        sin(
            _instance.x * 0.021 +
            _instance.y * 0.037
        ) *
        24634.6345
    );

var _strength_random =
    _strength_hash -
    floor(_strength_hash);

var _speed_hash =
    abs(
        sin(
            _instance.x * 0.043 +
            _instance.y * 0.019
        ) *
        35721.8731
    );

var _speed_random =
    _speed_hash -
    floor(_speed_hash);

var _strength_variation =
    0.85 +
    _strength_random * 0.30;

var _speed_variation =
    0.90 +
    _speed_random * 0.20;

var _final_strength =
    _strength *
    _strength_variation *
    _settings.wind_strength;

var _final_speed =
    _speed *
    _speed_variation *
    _settings.wind_speed;

    shader_set(
        shd_vegetation_sway
    );

    shader_set_uniform_f(
        _settings.uniform_sway,
        _time,
        _final_strength,
        _final_speed
    );

    shader_set_uniform_f(
        _settings.uniform_instance,
        _sprite_top,
        _sprite_bottom,
        _phase
    );

    shader_set_uniform_f(
        _settings.uniform_flash,
        1,
        1,
        1,
        clamp(
            _flash_amount,
            0,
            1
        )
    );

    draw_sprite_ext(
        _instance.sprite_index,
        _instance.image_index,
        _draw_x,
        _instance.y,
        _instance.image_xscale,
        _instance.image_yscale,
        _instance.image_angle,
        _instance.image_blend,
        _instance.image_alpha
    );

    shader_reset();

    return true;
}