if (!variable_global_exists("survival"))
{
    exit;
}

if (!sprite_exists(hud_sprite))
{
    exit;
}

var _stats = global.survival;


// ================================================================
// SAVE DRAW STATE
// ================================================================

var _old_color =
    draw_get_color();

var _old_alpha =
    draw_get_alpha();

var _old_halign =
    draw_get_halign();

var _old_valign =
    draw_get_valign();

var _old_font =
    draw_get_font();

draw_set_alpha(1);

if (hud_font != -1)
{
    draw_set_font(hud_font);
}


// ================================================================
// DRAW ONE SURVIVAL BAR
// ================================================================

var _draw_survival_bar = function(
    _value,
    _maximum,
    _row,
    _sprite_frame,
    _fill_color
)
{
    var _draw_x =
        hud_x;

    var _draw_y =
        hud_y +
        _row *
        hud_row_spacing *
        hud_scale;

    var _percent = 0;

    if (_maximum > 0)
    {
        _percent = clamp(
            _value / _maximum,
            0,
            1
        );
    }

    var _fill_y_offset =
        hud_fill_y[_sprite_frame];

    var _bar_x =
        _draw_x +
        hud_bar_x *
        hud_scale;

    var _bar_y =
        _draw_y +
        _fill_y_offset *
        hud_scale;

    var _bar_width =
        hud_bar_width *
        hud_scale;

    var _bar_height =
        hud_bar_height *
        hud_scale;


    // ------------------------------------------------------------
    // EMPTY BAR
    // ------------------------------------------------------------

    draw_set_color(empty_color);

    draw_rectangle(
        _bar_x,
        _bar_y,
        _bar_x + _bar_width,
        _bar_y + _bar_height,
        false
    );


    // ------------------------------------------------------------
    // FILLED BAR
    // ------------------------------------------------------------

    if (_percent > 0)
    {
        draw_set_color(_fill_color);

        draw_rectangle(
            _bar_x,
            _bar_y,
            _bar_x +
            floor(
                _bar_width *
                _percent
            ),

            _bar_y +
            _bar_height,
            false
        );
    }


    // ------------------------------------------------------------
    // HUD FRAME AND ICON
    // ------------------------------------------------------------

    if (_sprite_frame == 4)
    {
        // The supplied stamina frame only contains its icon.
        // Reuse only the empty bar portion from frame 1.
        draw_sprite_part_ext(
            hud_sprite,
            1,

            12,
            0,
            43,
            16,

            _draw_x +
            12 *
            hud_scale,

            _draw_y,

            hud_scale,
            hud_scale,

            c_white,
            1
        );

        // Draw the stamina icon over it.
        draw_sprite_ext(
            hud_sprite,
            4,
            _draw_x,
            _draw_y,
            hud_scale,
            hud_scale,
            0,
            c_white,
            1
        );
    }
    else
    {
        draw_sprite_ext(
            hud_sprite,
            _sprite_frame,
            _draw_x,
            _draw_y,
            hud_scale,
            hud_scale,
            0,
            c_white,
            1
        );
    }


    // ------------------------------------------------------------
    // NUMBER INSIDE BAR
    // ------------------------------------------------------------

    var _value_text =
        string(
            floor(_value)
        );

    var _value_x =
        _bar_x +
        _bar_width *
        0.5;

    var _value_y =
        _bar_y +
        _bar_height *
        0.5;

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    // Small shadow keeps the number readable over every color.
    draw_set_color(
        value_shadow_color
    );

    draw_text(
        _value_x + 1,
        _value_y + 1,
        _value_text
    );

    draw_set_color(
        value_color
    );

    draw_text(
        _value_x,
        _value_y,
        _value_text
    );
};


// ================================================================
// DRAW STATS
//
// Sprite frame mapping:
// 0 = Vitality
// 1 = Hydration
// 2 = Hunger
// 3 = Toxicity
// 4 = Stamina
// ================================================================

_draw_survival_bar(
    _stats.vitality,
    _stats.max_vitality,
    0,
    0,
    vitality_color
);

_draw_survival_bar(
    _stats.hunger,
    _stats.max_hunger,
    1,
    2,
    hunger_color
);

_draw_survival_bar(
    _stats.hydration,
    _stats.max_hydration,
    2,
    1,
    hydration_color
);

_draw_survival_bar(
    _stats.toxicity,
    _stats.max_toxicity,
    3,
    3,
    toxicity_color
);

_draw_survival_bar(
    _stats.stamina,
    _stats.max_stamina,
    4,
    4,
    stamina_color
);


// ================================================================
// EXHAUSTION WARNING
// ================================================================

if (_stats.exhausted)
{
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(stamina_color);

    draw_text(
        hud_x +
        13 *
        hud_scale,

        hud_y +
        5 *
        hud_row_spacing *
        hud_scale,

        "EXHAUSTED"
    );
}


// ================================================================
// DEATH WARNING
// ================================================================

if (_stats.is_dead)
{
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(vitality_color);

    draw_text(
        display_get_gui_width() *
        0.5,

        display_get_gui_height() *
        0.5,

        "VITALITY DEPLETED"
    );
}


// ================================================================
// RESTORE DRAW STATE
// ================================================================

draw_set_font(_old_font);
draw_set_color(_old_color);
draw_set_alpha(_old_alpha);
draw_set_halign(_old_halign);
draw_set_valign(_old_valign);