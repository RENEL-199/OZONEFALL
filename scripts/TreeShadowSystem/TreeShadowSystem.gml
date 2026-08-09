function tree_shadow_initialize()
{
    global.tree_shadow =
    {
        enabled: true,

        sprite:
            spr_tree_canopy_shadow,

        width_scale: 1,
        height_ratio: 0.65,

        offset_x: 3,
        offset_y: -5,

        color:
            make_color_rgb(
                38,
                45,
                34
            ),

        alpha: 0.32
    };

    return true;
}


function tree_shadow_draw(_tree)
{
    if (!instance_exists(_tree))
    {
        return false;
    }

    if (!sprite_exists(_tree.sprite_index))
    {
        return false;
    }

    if (
        !vegetation_sway_is_visible(
            _tree,
            64
        )
    )
    {
        return false;
    }

    if (
        variable_instance_exists(
            _tree,
            "shadow_enabled"
        ) &&
        !_tree.shadow_enabled
    )
    {
        return false;
    }

    if (!variable_global_exists("tree_shadow"))
    {
        tree_shadow_initialize();
    }

    var _settings =
        global.tree_shadow;

    if (!_settings.enabled)
    {
        return false;
    }

    var _shadow_sprite =
        _settings.sprite;

    if (
        variable_instance_exists(
            _tree,
            "shadow_sprite"
        )
    )
    {
        _shadow_sprite =
            _tree.shadow_sprite;
    }

    if (!sprite_exists(_shadow_sprite))
    {
        return false;
    }

    var _width_scale =
        _settings.width_scale;

    var _height_ratio =
        _settings.height_ratio;

    var _offset_x =
        _settings.offset_x;

    var _offset_y =
        _settings.offset_y;

    var _shadow_alpha =
        _settings.alpha;

    if (
        variable_instance_exists(
            _tree,
            "shadow_width_scale"
        )
    )
    {
        _width_scale =
            _tree.shadow_width_scale;
    }

    if (
        variable_instance_exists(
            _tree,
            "shadow_height_ratio"
        )
    )
    {
        _height_ratio =
            _tree.shadow_height_ratio;
    }

    if (
        variable_instance_exists(
            _tree,
            "shadow_offset_x"
        )
    )
    {
        _offset_x +=
            _tree.shadow_offset_x;
    }

    if (
        variable_instance_exists(
            _tree,
            "shadow_offset_y"
        )
    )
    {
        _offset_y +=
            _tree.shadow_offset_y;
    }

    if (
        variable_instance_exists(
            _tree,
            "shadow_alpha"
        )
    )
    {
        _shadow_alpha =
            _tree.shadow_alpha;
    }

    var _shadow_width =
        sprite_get_width(
            _tree.sprite_index
        ) *
        abs(_tree.image_xscale) *
        _width_scale;

    _shadow_width =
        max(
            8,
            _shadow_width
        );

    var _shadow_height =
        max(
            4,
            _shadow_width *
            _height_ratio
        );

    var _center_x =
        _tree.x +
        _offset_x;

    var _center_y =
        _tree.bbox_bottom +
        _offset_y;

    var _draw_x =
        _center_x -
        _shadow_width * 0.5;

    var _draw_y =
        _center_y -
        _shadow_height * 0.5;

    var _final_alpha =
        clamp(
            _shadow_alpha *
            _tree.image_alpha,
            0,
            1
        );

    var _old_alpha =
        draw_get_alpha();

    var _old_color =
        draw_get_color();

    draw_set_alpha(1);
    draw_set_color(c_white);

    draw_sprite_stretched_ext(
        _shadow_sprite,
        0,

        _draw_x,
        _draw_y,

        _shadow_width,
        _shadow_height,

        _settings.color,
        _final_alpha
    );

    draw_set_alpha(
        _old_alpha
    );

    draw_set_color(
        _old_color
    );

    return true;
}