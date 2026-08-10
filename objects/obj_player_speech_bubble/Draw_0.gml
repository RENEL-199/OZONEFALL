if (
    message == "" ||
    current_time >=
    message_finish_time
)
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

var _old_font =
    draw_get_font();

draw_set_font(
    fnt_speech_bubble
);

var _elapsed =
    current_time -
    message_start_time;

var _pop_progress =
    clamp(
        _elapsed /
        pop_duration_ms,
        0,
        1
    );

var _inverse =
    1 - _pop_progress;

var _pop_ease =
    1 -
    _inverse *
    _inverse *
    _inverse;

var _fade_alpha =
    clamp(
        (
            message_finish_time -
            current_time
        ) /
        fade_duration_ms,
        0,
        1
    );

var _alpha =
    min(
        _pop_ease,
        _fade_alpha
    );


var _visible_characters =
    clamp(
        floor(
            _elapsed /
            typing_ms_per_character
        ),
        0,
        string_length(message)
    );

var _visible_text =
    string_copy(
        message,
        1,
        _visible_characters
    );

var _is_typing =
    _visible_characters <
    string_length(message);


var _single_line_width =
    string_width(message) +
    horizontal_padding * 2;

var _needs_wrapping =
    _single_line_width >
    maximum_width;

var _bubble_width =
    clamp(
        _single_line_width,
        minimum_width,
        maximum_width
    );

var _bubble_height =
    _needs_wrapping
        ? wrapped_height
        : single_line_height;

var _current_width =
    round(
        _bubble_width *
        lerp(
            0.90,
            1,
            _pop_ease
        )
    );

var _current_height =
    round(
        _bubble_height *
        lerp(
            0.92,
            1,
            _pop_ease
        )
    );

var _bubble_x =
    round(
        _player.x -
        _current_width * 0.5
    );

var _bubble_y =
    round(
        _player.bbox_top -
        _current_height -
        tail_height -
        bubble_player_gap +
        (1 - _pop_ease) * 4
    );

var _bubble_right =
    _bubble_x +
    _current_width;

var _bubble_bottom =
    _bubble_y +
    _current_height;

var _tail_x =
    round(_player.x);


// Shadow
draw_set_alpha(
    _alpha * 0.5
);

draw_set_color(
    bubble_shadow_color
);

draw_rectangle(
    _bubble_x + 3,
    _bubble_y + 3,
    _bubble_right + 2,
    _bubble_bottom + 3,
    false
);


// Outline
draw_set_alpha(_alpha);

draw_set_color(
    bubble_outline_color
);

draw_rectangle(
    _bubble_x + 2,
    _bubble_y,
    _bubble_right - 2,
    _bubble_bottom,
    false
);

draw_rectangle(
    _bubble_x,
    _bubble_y + 2,
    _bubble_right,
    _bubble_bottom - 2,
    false
);


// Fill
draw_set_color(
    bubble_fill_color
);

draw_rectangle(
    _bubble_x + 2,
    _bubble_y + 2,
    _bubble_right - 2,
    _bubble_bottom - 2,
    false
);


// Highlight
draw_set_color(
    bubble_highlight_color
);

draw_rectangle(
    _bubble_x + 4,
    _bubble_y + 2,
    _bubble_right - 4,
    _bubble_y + 3,
    false
);


// Tail
draw_set_color(
    bubble_outline_color
);

draw_rectangle(
    _tail_x - 3,
    _bubble_bottom - 1,
    _tail_x + 3,
    _bubble_bottom + 1,
    false
);

draw_rectangle(
    _tail_x - 2,
    _bubble_bottom + 1,
    _tail_x + 2,
    _bubble_bottom + 3,
    false
);

draw_rectangle(
    _tail_x - 1,
    _bubble_bottom + 3,
    _tail_x + 1,
    _bubble_bottom + 5,
    false
);

draw_set_color(
    bubble_fill_color
);

draw_rectangle(
    _tail_x - 2,
    _bubble_bottom - 1,
    _tail_x + 2,
    _bubble_bottom + 1,
    false
);

draw_rectangle(
    _tail_x - 1,
    _bubble_bottom + 1,
    _tail_x + 1,
    _bubble_bottom + 2,
    false
);


// Text
var _wrap_width =
    _bubble_width -
    horizontal_padding * 2;

draw_set_halign(fa_center);
draw_set_valign(fa_top);

draw_set_color(
    bubble_text_color
);

draw_text_ext_transformed(
    _player.x,
    _bubble_y +
    vertical_padding,
    _visible_text,
    text_line_separation,
    _wrap_width,
    1,
    1,
    0
);


// Typing indicator
if (
    _is_typing &&
    (
        floor(
            current_time / 140
        ) mod 2
    ) == 0
)
{
    draw_set_color(
        typing_indicator_color
    );

    draw_rectangle(
        _bubble_right - 7,
        _bubble_bottom - 6,
        _bubble_right - 5,
        _bubble_bottom - 4,
        false
    );
}


draw_set_font(
    _old_font
);

draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_set_color(c_white);
draw_set_alpha(1);