/// obj_crafting_table_1 — Draw GUI Event


// ====================================================================
// UI VALIDATION
// ====================================================================

if (!is_open)
{
    exit;
}


var _ui =
    instance_find(
        obj_inventoryUI,
        0
    );


if (
    !instance_exists(_ui) ||
    !_ui.open ||
    _ui.container_instance != id ||
    !variable_global_exists("salvage_recipes")
)
{
    exit;
}


// ====================================================================
// UI LAYOUT
// ====================================================================

var _layout =
    crafting_ui_get_layout(
        _ui,
        self
    );


var _mouse_x =
    device_mouse_x_to_gui(0);


var _mouse_y =
    device_mouse_y_to_gui(0);


// ====================================================================
// RECIPE COUNT
// ====================================================================

var _recipe_count =
    array_length(
        global.salvage_recipes
    );


if (_recipe_count <= 0)
{
    exit;
}


// ====================================================================
// VISIBLE RECIPE COUNT
// ====================================================================

var _visible_count =
    max(
        1,
        floor(
            (
                _layout.list_h +
                recipe_row_gap
            )
            /
            (
                recipe_row_height +
                recipe_row_gap
            )
        )
    );


// ====================================================================
// SCROLL
// ====================================================================

var _maximum_scroll =
    max(
        0,
        _recipe_count -
        _visible_count
    );


recipe_scroll_index =
    clamp(
        recipe_scroll_index,
        0,
        _maximum_scroll
    );


// ====================================================================
// BACKGROUND
// ====================================================================

if (sprite_exists(salavage_UI))
{
    draw_sprite_stretched(
        salavage_UI,
        0,

        _layout.panel_x,
        _layout.panel_y,

        _layout.panel_w,
        _layout.panel_h
    );
}
else
{
    draw_set_color(
        craft_ui_background_color
    );

    draw_rectangle(
        _layout.panel_x,
        _layout.panel_y,

        _layout.panel_x +
        _layout.panel_w,

        _layout.panel_y +
        _layout.panel_h,

        false
    );

    draw_set_color(
        craft_ui_border_color
    );

    draw_rectangle(
        _layout.panel_x,
        _layout.panel_y,

        _layout.panel_x +
        _layout.panel_w,

        _layout.panel_y +
        _layout.panel_h,

        true
    );
}


// ====================================================================
// DIVIDER
// ====================================================================

draw_set_alpha(0.55);

draw_set_color(
    craft_ui_line_color
);

draw_line(
    _layout.divider_x,
    _layout.list_y - 12,

    _layout.divider_x,
    _layout.material_y - 18
);

draw_set_alpha(1);


// ====================================================================
// HEADERS
// ====================================================================

draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_set_color(
    craft_ui_text_color
);


draw_text(
    _layout.list_x,

    _layout.panel_y -
    14 +
    craft_ui_padding,

    "SALVAGE"
);


draw_text(
    _layout.detail_x,

    _layout.panel_y -
    16 +
    craft_ui_padding,

    "DISMANTLE"
);


// ====================================================================
// RECIPE LIST
// ====================================================================

for (
    var _visible_index = 0;

    _visible_index <
    _visible_count;

    _visible_index++
)
{
    var _recipe_index =
        recipe_scroll_index +
        _visible_index;


    if (
        _recipe_index >=
        _recipe_count
    )
    {
        break;
    }


    // IMPORTANT:
    // Use salvage_recipe_get()
    // NOT crafting_recipe_get()

    var _recipe =
        salvage_recipe_get(
            _recipe_index
        );


    if (
        is_undefined(_recipe) ||
        !is_struct(_recipe)
    )
    {
        continue;
    }


    var _row_x =
        _layout.list_x;


    var _row_y =
        _layout.list_y +
        _visible_index *
        (
            recipe_row_height +
            recipe_row_gap
        );


    var _row_width =
        _layout.list_w -
        recipe_scrollbar_width -
        8;


    var _row_hovered =
        point_in_rectangle(
            _mouse_x,
            _mouse_y,

            _row_x,
            _row_y,

            _row_x +
            _row_width,

            _row_y +
            recipe_row_height
        );


    var _row_selected =
        selected_recipe_id ==
        _recipe_index;


    // ------------------------------------------------------------
    // SELECTED BACKGROUND
    // ------------------------------------------------------------

    if (_row_selected)
    {
        draw_set_alpha(0.10);

        draw_set_color(c_black);

        draw_rectangle(
            _row_x,
            _row_y,

            _row_x +
            _row_width,

            _row_y +
            recipe_row_height,

            false
        );

        draw_set_alpha(1);

        draw_set_color(
            craft_ui_selected_color
        );

        draw_rectangle(
            _row_x,
            _row_y,

            _row_x +
            _row_width,

            _row_y +
            recipe_row_height,

            true
        );
    }


    // ------------------------------------------------------------
    // HOVER
    // ------------------------------------------------------------

    else if (
        _row_hovered &&
        !is_crafting
    )
    {
        draw_set_alpha(0.12);

        draw_set_color(c_white);

        draw_rectangle(
            _row_x,
            _row_y,

            _row_x +
            _row_width,

            _row_y +
            recipe_row_height,

            false
        );

        draw_set_alpha(1);
    }


    // ------------------------------------------------------------
    // RECIPE NAME
    // ------------------------------------------------------------

    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);

    draw_set_color(
        craft_ui_text_color
    );


    draw_text(
        _row_x + 16,

        _row_y +
        recipe_row_height * 0.5,

        string_upper(
            string(_recipe.name)
        )
    );
}


// ====================================================================
// SCROLLBAR
// ====================================================================

if (
    _recipe_count >
    _visible_count
)
{
    var _track_x =
        _layout.list_x +
        _layout.list_w -
        recipe_scrollbar_width;


    var _track_y =
        _layout.list_y;


    var _track_height =
        _layout.list_h;


    draw_set_alpha(0.30);

    draw_set_color(c_black);

    draw_rectangle(
        _track_x,
        _track_y,

        _track_x +
        recipe_scrollbar_width,

        _track_y +
        _track_height,

        false
    );


    draw_set_alpha(1);


    var _thumb_height =
        max(
            24,

            _track_height *
            (
                _visible_count /
                _recipe_count
            )
        );


    var _scroll_percent = 0;


    if (_maximum_scroll > 0)
    {
        _scroll_percent =
            recipe_scroll_index /
            _maximum_scroll;
    }


    var _thumb_y =
        _track_y +
        (
            _track_height -
            _thumb_height
        ) *
        _scroll_percent;


    draw_set_color(
        craft_ui_line_color
    );


    draw_rectangle(
        _track_x,
        _thumb_y,

        _track_x +
        recipe_scrollbar_width,

        _thumb_y +
        _thumb_height,

        false
    );
}


// ====================================================================
// SELECTED SALVAGE RECIPE
// ====================================================================

var _selected_recipe =
    salvage_recipe_get(
        selected_recipe_id
    );


if (
    !is_undefined(_selected_recipe) &&
    is_struct(_selected_recipe)
)
{
    // ================================================================
    // TITLE
    // ================================================================

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    draw_set_color(
        craft_ui_text_color
    );


    draw_text(
        _layout.detail_x,

        _layout.detail_y,

        string_upper(
            string(
                _selected_recipe.name
            )
        )
    );


    // ================================================================
    // REQUIRED MATERIALS HEADER
    // ================================================================

    var _ingredient_y =
        _layout.detail_y +
        48;


    draw_set_color(
        craft_ui_text_color
    );


    draw_text(
        _layout.detail_x,

        _ingredient_y,

        "REQUIRED"
    );


    // ================================================================
    // REQUIRED ITEMS
    // ================================================================

    var _required_count =
        array_length(
            _selected_recipe.item_required
        );


    for (
        var _required_index = 0;

        _required_index <
        _required_count;

        _required_index++
    )
    {
        var _required =
            _selected_recipe.item_required[
                _required_index
            ];


        var _item_data =
            item_get_data(
                _required.item_id
            );


        var _row_y =
            _ingredient_y +
            32 +
            _required_index *
            54;


        var _available =
            material_inventory.count_item(
                _required.item_id
            );


        var _has_enough =
            _available >=
            _required.amount;


        var _required_color =
            craft_ui_missing_color;


        if (_has_enough)
        {
            _required_color =
                craft_ui_available_color;
        }


        // ------------------------------------------------------------
        // ITEM ICON
        // ------------------------------------------------------------

        if (
            !is_undefined(_item_data) &&
            sprite_exists(
                _item_data.sprite
            )
        )
        {
            var _scale =
                min(
                    ingredient_icon_size /
                    sprite_get_width(
                        _item_data.sprite
                    ),

                    ingredient_icon_size /
                    sprite_get_height(
                        _item_data.sprite
                    )
                );


            draw_sprite_ext(
                _item_data.sprite,
                0,

                _layout.detail_x +
                ingredient_icon_size * 0.5,

                _row_y +
                ingredient_icon_size * 0.5,

                _scale,
                _scale,

                0,

                c_white,

                1
            );
        }


        // ------------------------------------------------------------
        // ITEM NAME
        // ------------------------------------------------------------

        var _item_name =
            "Unknown";


        if (!is_undefined(_item_data))
        {
            _item_name =
                string(_item_data.name);
        }


        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);

        draw_set_color(
            craft_ui_text_color
        );


        draw_text(
            _layout.detail_x +
            ingredient_icon_size +
            8,

            _row_y +
            ingredient_icon_size * 0.5,

            _item_name
        );


        // ------------------------------------------------------------
        // AMOUNT
        // ------------------------------------------------------------

        draw_set_halign(fa_right);

        draw_set_color(
            _required_color
        );


        draw_text(
            _layout.detail_x +
            _layout.detail_w,

            _row_y +
            ingredient_icon_size * 0.5,

            string(_available) +
            "/" +
            string(_required.amount)
        );
    }


    // ================================================================
    // OUTPUTS
    // ================================================================

    var _output_y =
        _ingredient_y +
        32 +
        _required_count * 54 +
        18;


    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    draw_set_color(
        craft_ui_text_color
    );


    draw_text(
        _layout.detail_x,

        _output_y,

        "OUTPUT"
    );


    var _output_count =
        array_length(
            _selected_recipe.output
        );


    for (
        var _output_index = 0;

        _output_index <
        _output_count;

        _output_index++
    )
    {
        var _output =
            _selected_recipe.output[
                _output_index
            ];


        var _output_data =
            item_get_data(
                _output.item_id
            );


        var _output_row_y =
            _output_y +
            32 +
            _output_index *
            46;


        // ------------------------------------------------------------
        // OUTPUT ICON
        // ------------------------------------------------------------

        if (
            !is_undefined(_output_data) &&
            sprite_exists(
                _output_data.sprite
            )
        )
        {
            var _output_scale =
                min(
                    32 /
                    sprite_get_width(
                        _output_data.sprite
                    ),

                    32 /
                    sprite_get_height(
                        _output_data.sprite
                    )
                );


            draw_sprite_ext(
                _output_data.sprite,
                0,

                _layout.detail_x +
                16,

                _output_row_y +
                16,

                _output_scale,
                _output_scale,

                0,

                c_white,

                1
            );
        }


        // ------------------------------------------------------------
        // OUTPUT NAME
        // ------------------------------------------------------------

        var _output_name =
            _output.name;


        if (
            is_undefined(
                _output_name
            )
        )
        {
            if (!is_undefined(_output_data))
            {
                _output_name =
                    _output_data.name;
            }
            else
            {
                _output_name =
                    "Unknown";
            }
        }


        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);

        draw_set_color(
            craft_ui_text_color
        );


        draw_text(
            _layout.detail_x +
            38,

            _output_row_y +
            16,

            string(_output_name)
        );


        // ------------------------------------------------------------
        // OUTPUT AMOUNT
        // ------------------------------------------------------------

        draw_set_halign(fa_right);


        draw_text(
            _layout.detail_x +
            _layout.detail_w,

            _output_row_y +
            16,

            "x" +
            string(
                _output.amount
            )
        );
    }


    // ================================================================
    // TIME / COST
    // ================================================================

    var _cost_y =
        _output_y +
        32 +
        _output_count * 46 +
        12;


    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    draw_set_color(
        craft_ui_available_color
    );


    draw_text(
        _layout.detail_x,

        _cost_y,

        string(
            _selected_recipe.duration_minutes
        ) +
        " MIN"
    );


    draw_text(
        _layout.detail_x +
        100,

        _cost_y,

        "-" +
        string(
            _selected_recipe.hunger_cost
        ) +
        " HUNGER"
    );


    draw_text(
        _layout.detail_x +
        220,

        _cost_y,

        "-" +
        string(
            _selected_recipe.hydration_cost
        ) +
        " WATER"
    );
}


// ====================================================================
// MATERIAL INPUT SLOTS
// ====================================================================

draw_set_halign(fa_left);
draw_set_valign(fa_bottom);

draw_set_color(
    craft_ui_text_color
);


draw_text(
    _layout.material_x,

    _layout.material_y - 6,

    "MATERIALS"
);


for (
    var _material_slot = 0;

    _material_slot <
    material_inventory.size;

    _material_slot++
)
{
    var _slot_x =
        _layout.material_x +
        _material_slot *
        (
            _layout.material_slot_size +
            _layout.material_gap
        );


    var _slot_y =
        _layout.material_y;


    var _slot_background =
        spr_material_slot;


    if (
        _ui.selected_inventory ==
        material_inventory &&
        _ui.selected_slot ==
        _material_slot
    )
    {
        _slot_background =
            _ui.slot_selected_sprite;
    }


    if (
        _ui.hovered_inventory ==
        material_inventory &&
        _ui.hovered_slot ==
        _material_slot
    )
    {
        _slot_background =
            _ui.slot_selected_sprite;
    }


    if (
        sprite_exists(
            _slot_background
        )
    )
    {
        draw_sprite_stretched(
            _slot_background,
            0,

            _slot_x,
            _slot_y,

            _layout.material_slot_size,
            _layout.material_slot_size
        );
    }


    var _slot =
        material_inventory.slots[
            _material_slot
        ];


    if (_slot.is_empty())
    {
        continue;
    }


    var _slot_hidden =
        _ui.dragging &&
        _ui.drag_source_inventory ==
        material_inventory &&
        _ui.drag_source_slot ==
        _material_slot;


    if (_slot_hidden)
    {
        continue;
    }


    var _item_data =
        item_get_data(
            _slot.item_id
        );


    if (
        is_undefined(_item_data) ||
        !sprite_exists(
            _item_data.sprite
        )
    )
    {
        continue;
    }


    var _item_size =
        _layout.material_slot_size -
        16;


    var _item_scale =
        min(
            _item_size /
            sprite_get_width(
                _item_data.sprite
            ),

            _item_size /
            sprite_get_height(
                _item_data.sprite
            )
        );


    draw_sprite_ext(
        _item_data.sprite,
        0,

        _slot_x +
        _layout.material_slot_size * 0.5,

        _slot_y +
        _layout.material_slot_size * 0.5,

        _item_scale,
        _item_scale,

        0,

        c_white,

        1
    );


    if (_slot.amount > 1)
    {
        draw_set_halign(fa_right);
        draw_set_valign(fa_bottom);

        draw_set_color(c_white);


        draw_text(
            _slot_x +
            _layout.material_slot_size -
            4,

            _slot_y +
            _layout.material_slot_size -
            4,

            string(
                _slot.amount
            )
        );
    }
}


// ====================================================================
// CRAFT / SALVAGE BUTTON
// ====================================================================

var _craft_hovered =
    point_in_rectangle(
        _mouse_x,
        _mouse_y,

        _layout.craft_x,
        _layout.craft_y,

        _layout.craft_x +
        _layout.craft_w,

        _layout.craft_y +
        _layout.craft_h
    );


var _can_craft =
    can_start_crafting();


var _button_y =
    _layout.craft_y;


if (
    craft_button_press_timer > 0
)
{
    _button_y += 2;
}


// ====================================================================
// BUTTON SPRITE
// ====================================================================

if (
    sprite_exists(
        spr_craft_button
    )
)
{
    draw_sprite_stretched(
        spr_craft_button,
        0,

        _layout.craft_x,
        _button_y,

        _layout.craft_w,
        _layout.craft_h
    );
}
else
{
    draw_set_color(
        craft_ui_panel_color
    );


    draw_rectangle(
        _layout.craft_x,
        _button_y,

        _layout.craft_x +
        _layout.craft_w,

        _button_y +
        _layout.craft_h,

        false
    );
}


// ====================================================================
// DISABLED / HOVER
// ====================================================================

if (!_can_craft && !is_crafting)
{
    draw_set_alpha(0.52);

    draw_set_color(c_black);


    draw_rectangle(
        _layout.craft_x,
        _button_y,

        _layout.craft_x +
        _layout.craft_w,

        _button_y +
        _layout.craft_h,

        false
    );


    draw_set_alpha(1);
}
else if (
    _craft_hovered &&
    !is_crafting
)
{
    draw_set_alpha(0.16);

    draw_set_color(c_white);


    draw_rectangle(
        _layout.craft_x,
        _button_y,

        _layout.craft_x +
        _layout.craft_w,

        _button_y +
        _layout.craft_h,

        false
    );


    draw_set_alpha(1);
}


// ====================================================================
// BUTTON TEXT
// ====================================================================

var _button_text =
    "SALVAGE";


if (is_crafting)
{
    _button_text =
        "WORKING";
}
else if (
    array_length(
        pending_outputs
    ) > 0
)
{
    _button_text =
        "COLLECT";
}
else if (!_can_craft)
{
    _button_text =
        "MISSING";
}


var _button_text_color =
    craft_ui_disabled_color;


if (
    _can_craft ||
    array_length(pending_outputs) > 0
)
{
    _button_text_color =
        craft_ui_text_color;
}


draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_color(
    _button_text_color
);


draw_text(
    _layout.craft_x +
    _layout.craft_w * 0.5,

    _button_y +
    _layout.craft_h * 0.5,

    _button_text
);


// ====================================================================
// PROGRESS BAR
// ====================================================================

if (is_crafting)
{
    var _progress =
        salvage_get_process(
            craft_start_timestamp,
            craft_finish_timestamp
        );


    _progress =
        clamp(
            _progress,
            0,
            1
        );


    // ------------------------------------------------------------
    // BAR BACKGROUND
    // ------------------------------------------------------------

    if (
        sprite_exists(
            spr_progress_bar
        )
    )
    {
        draw_sprite_stretched(
            spr_progress_bar,
            0,

            _layout.progress_x,
            _layout.progress_y,

            _layout.progress_w,
            _layout.progress_h
        );
    }
    else
    {
        draw_set_alpha(0.45);

        draw_set_color(c_black);


        draw_rectangle(
            _layout.progress_x,
            _layout.progress_y,

            _layout.progress_x +
            _layout.progress_w,

            _layout.progress_y +
            _layout.progress_h,

            false
        );


        draw_set_alpha(1);
    }


    // ------------------------------------------------------------
    // BAR FILL
    // ------------------------------------------------------------

    if (
        _progress > 0 &&
        sprite_exists(
            spr_progressbar_fill
        )
    )
    {
        draw_sprite_stretched(
            spr_progressbar_fill,
            0,

            _layout.progress_x,
            _layout.progress_y,

            _layout.progress_w *
            _progress,

            _layout.progress_h
        );
    }


    // ------------------------------------------------------------
    // PERCENTAGE
    // ------------------------------------------------------------

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_set_color(c_white);


    draw_text(
        _layout.progress_x +
        _layout.progress_w * 0.5,

        _layout.progress_y +
        _layout.progress_h * 0.5,

        string(
            floor(
                _progress * 100
            )
        ) +
        "%"
    );
}


// ====================================================================
// COMPLETION FLASH
// ====================================================================

if (
    craft_complete_flash_timer > 0
)
{
    draw_set_alpha(
        craft_complete_flash_timer /
        60
    );


    draw_set_color(c_white);


    draw_rectangle(
        _layout.panel_x,
        _layout.panel_y,

        _layout.panel_x +
        _layout.panel_w,

        _layout.panel_y +
        _layout.panel_h,

        false
    );


    draw_set_alpha(1);
}


// ====================================================================
// STATUS MESSAGE
// ====================================================================

if (
    craft_message_timer > 0 &&
    string_length(craft_message) > 0
)
{
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);

    draw_set_color(
        craft_ui_text_color
    );


    draw_text(
        _layout.detail_x +
        _layout.detail_w * 0.5,

        _layout.craft_y - 12,

        craft_message
    );
}


// ====================================================================
// RESET DRAW STATE
// ====================================================================

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);