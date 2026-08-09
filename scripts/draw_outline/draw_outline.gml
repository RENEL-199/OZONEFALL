function draw_outline(_spr, _subimg, _x, _y, _color)
{
    draw_sprite_ext(_spr, _subimg, _x - 1, _y, 1, 1, 0, _color, 1);
    draw_sprite_ext(_spr, _subimg, _x + 1, _y, 1, 1, 0, _color, 1);
    draw_sprite_ext(_spr, _subimg, _x, _y - 1, 1, 1, 0, _color, 1);
    draw_sprite_ext(_spr, _subimg, _x, _y + 1, 1, 1, 0, _color, 1);

    draw_sprite(_spr, _subimg, _x, _y);
}