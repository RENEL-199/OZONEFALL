function campfire_ui_update_layout(_campfire)
{
    if (!instance_exists(_campfire))
    {
        return false;
    }

    var _gui_width =
        display_get_gui_width();

    var _gui_height =
        display_get_gui_height();

    var _margin =
        _campfire.cooking_ui_margin;

    var _available_width =
        max(
            1,
            _gui_width - _margin * 2
        );

    var _available_height =
        max(
            1,
            _gui_height - _margin * 2
        );

    var _scale =
        min(
            1,
            _available_width /
            _campfire.cooking_ui_design_width,
            _available_height /
            _campfire.cooking_ui_design_height
        );

    _campfire.cooking_ui_scale =
        _scale;

    _campfire.cooking_ui_width =
        floor(
            _campfire.cooking_ui_design_width *
            _scale
        );

    _campfire.cooking_ui_height =
        floor(
            _campfire.cooking_ui_design_height *
            _scale
        );

    _campfire.cooking_ui_recipe_width =
        floor(220 * _scale);

    _campfire.cooking_ui_recipe_height =
        floor(62 * _scale);

    _campfire.cooking_ui_recipe_gap =
        floor(8 * _scale);

    _campfire.cooking_ui_button_width =
        floor(170 * _scale);

    _campfire.cooking_ui_button_height =
        floor(48 * _scale);

    _campfire.cooking_ui_text_scale =
        0.88 * _scale;

    _campfire.cooking_ui_small_text_scale =
        0.70 * _scale;


    var _campfire_gui_x =
        _gui_width * 0.5;

    var _campfire_gui_y =
        _gui_height * 0.5;

    var _camera =
        view_camera[0];

    if (_camera != -1)
    {
        var _camera_x =
            camera_get_view_x(_camera);

        var _camera_y =
            camera_get_view_y(_camera);

        var _camera_width =
            camera_get_view_width(_camera);

        var _camera_height =
            camera_get_view_height(_camera);

        if (
            _camera_width > 0 &&
            _camera_height > 0
        )
        {
            _campfire_gui_x =
                (
                    (_campfire.x - _camera_x) /
                    _camera_width
                ) *
                _gui_width;

            _campfire_gui_y =
                (
                    (
                        _campfire.bbox_bottom -
                        _camera_y
                    ) /
                    _camera_height
                ) *
                _gui_height;
        }
    }

    _campfire.cooking_ui_anchor_x =
        _campfire_gui_x;

    _campfire.cooking_ui_anchor_y =
        _campfire_gui_y;


    var _gap =
        _campfire.cooking_ui_side_gap *
        _scale;

    var _right_x =
        _campfire_gui_x + _gap;

    var _left_x =
        _campfire_gui_x -
        _campfire.cooking_ui_width -
        _gap;

    var _target_x;
    var _side;

    if (
        _right_x +
        _campfire.cooking_ui_width <=
        _gui_width - _margin
    )
    {
        _target_x = _right_x;
        _side = 1;
    }
    else if (_left_x >= _margin)
    {
        _target_x = _left_x;
        _side = -1;
    }
    else
    {
        _target_x =
            (
                _gui_width -
                _campfire.cooking_ui_width
            ) *
            0.5;

        _side = 0;
    }

    var _target_y =
        _campfire_gui_y -
        _campfire.cooking_ui_height *
        0.5;

    _target_y =
        clamp(
            _target_y,
            _margin,
            _gui_height -
            _campfire.cooking_ui_height -
            _margin
        );

    var _slide_offset =
        (
            1 -
            _campfire.cooking_ui_open_amount
        ) *
        30 *
        _side;

    _campfire.cooking_ui_x =
        round(
            _target_x +
            _slide_offset
        );

    _campfire.cooking_ui_y =
        round(_target_y);

    _campfire.cooking_ui_side =
        _side;

    return true;
}