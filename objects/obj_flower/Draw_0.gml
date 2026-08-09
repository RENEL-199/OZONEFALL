event_inherited();

var sway_offset = sin(sway) * sway_strength * 5;
draw_sprite_ext(spr_flower, 0, x, y, 1, 1, sway_offset, c_white, 1);