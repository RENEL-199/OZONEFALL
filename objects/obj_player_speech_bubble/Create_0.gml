if (instance_number(object_index) > 1)
{
    instance_destroy();
    exit;
}

persistent = true;

depth = -1000000;

message = "";

message_start_time = 0;
typing_finish_time = 0;
message_finish_time = 0;

typing_ms_per_character = 32;

minimum_width = 66;
maximum_width = 122;

single_line_height = 26;
wrapped_height = 40;

horizontal_padding = 8;
vertical_padding = 6;

bubble_player_gap = 32;
tail_height = 5;

text_scale = 0.8;
text_line_separation = -1;

pop_duration_ms = 140;
fade_duration_ms = 240;

bubble_outline_color =
    make_color_rgb(
        31,
        34,
        48
    );

bubble_shadow_color =
    make_color_rgb(
        19,
        21,
        30
    );

bubble_fill_color =
    make_color_rgb(
        244,
        233,
        199
    );

bubble_highlight_color =
    make_color_rgb(
        255,
        250,
        225
    );

bubble_text_color =
    make_color_rgb(
        42,
        37,
        42
    );

typing_indicator_color =
    make_color_rgb(
        191,
        104,
        63
    );


set_bubble_message = function(
    _message,
    _hold_duration_ms = 1800
)
{
    message =
        string(_message);

    message_start_time =
        current_time;

    typing_finish_time =
        message_start_time +
        string_length(message) *
        typing_ms_per_character;

    message_finish_time =
        typing_finish_time +
        max(
            500,
            _hold_duration_ms
        );

    return true;
};