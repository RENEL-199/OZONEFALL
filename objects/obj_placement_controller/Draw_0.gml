if (!placement_active)
{
    exit;
}


var _player =
    instance_find(
        obj_player,
        0
    );

if (!instance_exists(_player))
{
    exit;
}


var _grid =
    placement_grid_size;

var _half_grid =
    _grid *
    0.5;


var _left_column =
    floor(
        (
            _player.x -
            maximum_placement_distance
        ) /
        _grid
    );

var _right_column =
    ceil(
        (
            _player.x +
            maximum_placement_distance
        ) /
        _grid
    );

var _top_row =
    floor(
        (
            _player.bbox_bottom -
            maximum_placement_distance
        ) /
        _grid
    );

var _bottom_row =
    ceil(
        (
            _player.bbox_bottom +
            maximum_placement_distance
        ) /
        _grid
    );


// White placement grid
draw_set_color(c_white);
draw_set_alpha(
    grid_outline_alpha
);

for (
    var _grid_y = _top_row;
    _grid_y <= _bottom_row;
    _grid_y++
)
{
    for (
        var _grid_x = _left_column;
        _grid_x <= _right_column;
        _grid_x++
    )
    {
        var _cell_x =
            _grid_x *
            _grid +
            _half_grid;

        var _cell_y =
            _grid_y *
            _grid +
            _half_grid;

        var _cell_distance =
            point_distance(
                _player.x,
                _player.bbox_bottom,
                _cell_x,
                _cell_y
            );

        if (
            _cell_distance >
            maximum_placement_distance
        )
        {
            continue;
        }

        draw_rectangle(
            _cell_x -
            _half_grid,
            _cell_y -
            _half_grid,
            _cell_x +
            _half_grid,
            _cell_y +
            _half_grid,
            true
        );
    }
}


// Selected cell
if (preview_valid)
{
    draw_set_color(
        valid_color
    );
}
else
{
    draw_set_color(
        invalid_color
    );
}

draw_set_alpha(
    selected_grid_alpha
);

draw_rectangle(
    preview_x -
    placement_cell_width * 0.5,
    preview_y -
    placement_cell_height * 0.5,
    preview_x +
    placement_cell_width * 0.5,
    preview_y +
    placement_cell_height * 0.5,
    true
);


// Item preview
if (
    sprite_exists(
        placement_sprite
    )
)
{
    var _preview_blend =
        valid_color;

    if (!preview_valid)
    {
        _preview_blend =
            invalid_color;
    }

    draw_sprite_ext(
        placement_sprite,
        0,
        preview_x,
        preview_y,
        1,
        1,
        0,
        _preview_blend,
        preview_alpha
    );
}


// Placement controls
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_color(c_white);
draw_set_alpha(0.90);

draw_text_transformed(
    preview_x,
    preview_y -
    placement_cell_height * 0.5 -
    5,
    "[LMB] Place   [RMB] Cancel",
    0.45,
    0.45,
    0
);


draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);