if (!variable_global_exists("game_time"))
{
    exit;
}

var _darkness =
    global.game_time.get_darkness();

if (_darkness <= 0)
{
    exit;
}

var _camera =
    view_camera[0];

if (_camera == -1)
{
    exit;
}

var _camera_x =
    camera_get_view_x(_camera);

var _camera_y =
    camera_get_view_y(_camera);

var _camera_width =
    ceil(
        camera_get_view_width(_camera)
    );

var _camera_height =
    ceil(
        camera_get_view_height(_camera)
    );


var _surface_invalid =
    !surface_exists(
        lighting_surface
    );

if (!_surface_invalid)
{
    _surface_invalid =
        surface_get_width(
            lighting_surface
        ) != _camera_width ||
        surface_get_height(
            lighting_surface
        ) != _camera_height;
}

if (_surface_invalid)
{
    if (surface_exists(lighting_surface))
    {
        surface_free(lighting_surface);
    }

    lighting_surface =
        surface_create(
            _camera_width,
            _camera_height
        );
}

if (!surface_exists(lighting_surface))
{
    exit;
}


// Build darkness mask
surface_set_target(
    lighting_surface
);

draw_clear_alpha(
    night_color,
    _darkness
);


// Remove darkness around every burning campfire
gpu_set_blendmode_ext(
    bm_zero,
    bm_inv_src_alpha
);

var _campfire_count =
    instance_number(
        obj_campfire
    );

for (
    var _i = 0;
    _i < _campfire_count;
    _i++
)
{
    var _campfire =
        instance_find(
            obj_campfire,
            _i
        );

    if (
        !instance_exists(_campfire) ||
        !_campfire.lit
    )
    {
        continue;
    }

    var _light_x =
        _campfire.x -
        _camera_x;

    var _light_y =
        _campfire.y -
        _camera_y +
        _campfire.light_y_offset;

    var _radius =
        _campfire.light_radius *
        _campfire.light_flicker;

    for (
        var _layer =
            light_falloff_layers;

        _layer >= 1;

        _layer--
    )
    {
        var _weight =
            _layer /
            light_falloff_layers;

        var _erase_alpha =
            (
                0.12 +
                (1 - _weight) * 0.10
            ) *
            _campfire.light_strength;

        draw_set_alpha(
            _erase_alpha
        );

        draw_set_color(c_white);

        draw_circle(
            _light_x,
            _light_y,
            _radius * _weight,
            false
        );
    }
}


gpu_set_blendmode(bm_normal);

draw_set_alpha(1);
draw_set_color(c_white);

surface_reset_target();


// Draw completed darkness mask over the world
draw_surface(
    lighting_surface,
    _camera_x,
    _camera_y
);


// Add a subtle warm center
gpu_set_blendmode(bm_add);

for (
    var _i = 0;
    _i < _campfire_count;
    _i++
)
{
    var _campfire =
        instance_find(
            obj_campfire,
            _i
        );

    if (
        !instance_exists(_campfire) ||
        !_campfire.lit
    )
    {
        continue;
    }

    var _warm_radius =
        _campfire.light_radius *
        0.42 *
        _campfire.light_flicker;

    draw_set_color(
        _campfire.light_color
    );

    for (
        var _warm_layer = 4;
        _warm_layer >= 1;
        _warm_layer--
    )
    {
        draw_set_alpha(
            _darkness *
            _campfire.warm_glow_strength *
            0.08
        );

        draw_circle(
            _campfire.x,
            _campfire.y +
            _campfire.light_y_offset,
            _warm_radius *
            (_warm_layer / 4),
            false
        );
    }
}


gpu_set_blendmode(bm_normal);

draw_set_alpha(1);
draw_set_color(c_white);