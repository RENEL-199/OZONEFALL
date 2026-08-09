if (!sprite_exists(scatter_sprite))
{
    exit;
}

draw_set_alpha(
    scatter_alpha
);

draw_set_color(c_white);

var _scatter_count =
    array_length(
        scatter_x
    );

for (
    var _i = 0;
    _i < _scatter_count;
    _i++
)
{
    draw_sprite_ext(
        scatter_sprite,
        scatter_frame[_i],
        scatter_x[_i],
        scatter_y[_i],
        scatter_xscale[_i],
        1,
        0,
        c_white,
        scatter_alpha
    );
}

draw_set_alpha(1);
draw_set_color(c_white);