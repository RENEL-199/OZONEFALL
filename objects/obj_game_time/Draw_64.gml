if (!variable_global_exists("game_time"))
{
    exit;
}

var _time_text =
    global.game_time.get_time_string();

var _gui_width =
    display_get_gui_width();

var _right_margin = 24;
var _top_margin = 24;

var _clock_x =
    _gui_width -
    clock_background_width -
    _right_margin;

var _clock_y =
    _top_margin;


var _old_color =
    draw_get_color();

var _old_alpha =
    draw_get_alpha();

var _old_halign =
    draw_get_halign();

var _old_valign =
    draw_get_valign();


// Background
draw_set_alpha(0.80);
draw_set_color(c_black);

draw_rectangle(
    _clock_x,
    _clock_y,
    _clock_x +
    clock_background_width,

    _clock_y +
    clock_background_height,
    false
);


// Border
draw_set_alpha(1);
draw_set_color(c_white);

draw_rectangle(
    _clock_x,
    _clock_y,
    _clock_x +
    clock_background_width,

    _clock_y +
    clock_background_height,
    true
);


// Time
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);

draw_text(
    _clock_x +
    clock_background_width *
    0.5,

    _clock_y +
    clock_background_height *
    0.5,

    _time_text
);


// Restore draw state
draw_set_color(_old_color);
draw_set_alpha(_old_alpha);
draw_set_halign(_old_halign);
draw_set_valign(_old_valign);