function draw_highlight(_spr, _subimg, _x, _y)
{
    shader_set(shd_solid_color);

    var _uniform =
        shader_get_uniform(
            shd_solid_color,
            "solid_color"
        );

    shader_set_uniform_f(
        _uniform,
        1,
        1,
        1,
        1
    );

    // Straight outline
    draw_sprite(_spr, _subimg, _x - 1, _y);
    draw_sprite(_spr, _subimg, _x + 1, _y);
    draw_sprite(_spr, _subimg, _x, _y - 1);
    draw_sprite(_spr, _subimg, _x, _y + 1);

    // Diagonal outline
    draw_sprite(_spr, _subimg, _x - 1, _y - 1);
    draw_sprite(_spr, _subimg, _x + 1, _y - 1);
    draw_sprite(_spr, _subimg, _x - 1, _y + 1);
    draw_sprite(_spr, _subimg, _x + 1, _y + 1);

    shader_reset();

    // Original sprite
    draw_sprite(
        _spr,
        _subimg,
        _x,
        _y
    );
}

