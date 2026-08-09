/// obj_crafting_table — Draw GUI Event

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
    !variable_global_exists(
        "crafting_recipes"
    )
)
{
    exit;
}

var _layout =
    crafting_ui_get_layout(
        _ui,
        self
    );

var _mouse_x =
    device_mouse_x_to_gui(0);

var _mouse_y =
    device_mouse_y_to_gui(0);

var _recipe_count =
    array_length(
        global.crafting_recipes
    );

var _visible_count =
    max(
        1,
        floor(
            (
                _layout.list_h +
                recipe_row_gap
            ) /
            (
                recipe_row_height +
                recipe_row_gap
            )
        )
    );

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

if (sprite_exists(spr_crafting_bg))
{
    draw_sprite_stretched(
        spr_crafting_bg,
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
    _layout.panel_y - 14 +
    craft_ui_padding,
    "RECIPES"
);

draw_text(
    _layout.detail_x,
    _layout.panel_y - 16 +
    craft_ui_padding,
    "CRAFTING"
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

    if (_recipe_index >= _recipe_count)
    {
        break;
    }

    var _recipe =
        crafting_recipe_get(
            _recipe_index
        );

    if (is_undefined(_recipe))
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
            _row_x + _row_width,
            _row_y +
            recipe_row_height
        );

    var _row_selected =
        selected_recipe_id ==
        _recipe_index;

    if (_row_selected)
    {
        draw_set_alpha(0.10);
        draw_set_color(c_black);

        draw_rectangle(
            _row_x,
            _row_y,
            _row_x + _row_width,
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
            _row_x + _row_width,
            _row_y +
            recipe_row_height,
            true
        );
    }
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
            _row_x + _row_width,
            _row_y +
            recipe_row_height,
            false
        );

        draw_set_alpha(1);
    }

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
            _recipe.name
        )
    );
}


// ====================================================================
// SCROLLBAR
// ====================================================================

if (_recipe_count > _visible_count)
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
// SELECTED RECIPE
// ====================================================================

var _selected_recipe =
    crafting_recipe_get(
        selected_recipe_id
    );

if (!is_undefined(_selected_recipe))
{
    var _output_data =
        item_get_data(
            _selected_recipe
                .output_item_id
        );

    var _icon_x =
        _layout.detail_x +
        recipe_icon_size * 0.5;

    var _icon_y =
        _layout.detail_y +
        recipe_icon_size * 0.5;

    if (
        !is_undefined(_output_data) &&
        sprite_exists(
            _output_data.sprite
        )
    )
    {
        var _output_scale =
            min(
                recipe_icon_size /
                sprite_get_width(
                    _output_data.sprite
                ),

                recipe_icon_size /
                sprite_get_height(
                    _output_data.sprite
                )
            );

        draw_sprite_ext(
            _output_data.sprite,
            0,
            _icon_x,
            _icon_y,
            _output_scale,
            _output_scale,
            0,
            c_white,
            1
        );
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(
        craft_ui_text_color
    );

    draw_text(
        _layout.detail_x +
        recipe_icon_size + 32,
        _layout.detail_y + 8,
        string_upper(
            _selected_recipe.name
        )
    );

    draw_set_halign(fa_right);

    draw_text(
        _layout.detail_x +
        _layout.detail_w,
        _layout.detail_y + 8,
        "x" +
        string(
            _selected_recipe
                .output_amount
        )
    );


    // ================================================================
    // INGREDIENTS
    // ================================================================

    var _ingredient_y =
        _layout.detail_y +
        recipe_icon_size + 34;

    var _ingredient_count =
        array_length(
            _selected_recipe.ingredients
        );

    for (
        var _ingredient_index = 0;
        _ingredient_index <
        _ingredient_count;
        _ingredient_index++
    )
    {
        var _ingredient =
            _selected_recipe
                .ingredients[
                    _ingredient_index
                ];

        var _ingredient_data =
            item_get_data(
                _ingredient.item_id
            );

        var _row_y =
            _ingredient_y +
            _ingredient_index * 54;

        var _available =
            material_inventory
                .count_item(
                    _ingredient.item_id
                );

        var _has_enough =
            _available >=
            _ingredient.amount;

        var _ingredient_color =
            craft_ui_missing_color;

        if (_has_enough)
        {
            _ingredient_color =
                craft_ui_available_color;
        }

        if (
            !is_undefined(
                _ingredient_data
            ) &&
            sprite_exists(
                _ingredient_data.sprite
            )
        )
        {
            var _ingredient_scale =
                min(
                    ingredient_icon_size /
                    sprite_get_width(
                        _ingredient_data.sprite
                    ),

                    ingredient_icon_size /
                    sprite_get_height(
                        _ingredient_data.sprite
                    )
                );

            draw_sprite_ext(
                _ingredient_data.sprite,
                0,
                _layout.detail_x +
                ingredient_icon_size * 0.5,
                _row_y +
                ingredient_icon_size * 0.5,
                _ingredient_scale,
                _ingredient_scale,
                0,
                c_white,
                1
            );
        }

        var _ingredient_name =
            "Unknown";

        if (!is_undefined(_ingredient_data))
        {
            _ingredient_name =
                _ingredient_data.name;
        }

        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_set_color(
            craft_ui_text_color
        );

        draw_text(
            _layout.detail_x +
            ingredient_icon_size + 5,
            _row_y +
            ingredient_icon_size * 0.5,
            _ingredient_name
        );

        draw_set_halign(fa_right);
        draw_set_color(
            _ingredient_color
        );

        draw_text(
            _layout.detail_x +
            _layout.detail_w,
            _row_y +
            ingredient_icon_size * 0.5,
            string(_available) +
            "/" +
            string(
                _ingredient.amount
            )
        );
    }


    // ================================================================
    // TIME AND COST
    // ================================================================

    var _cost_y =
        _ingredient_y +
        _ingredient_count * 54 +
        14;

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(
        craft_ui_available_color
    );

    draw_text(
        _layout.detail_x,
        _cost_y,
        string(
            _selected_recipe
                .duration_minutes
        ) +
        " MIN"
    );

    draw_text(
        _layout.detail_x + 110,
        _cost_y,
        "-" +
        string(
            _selected_recipe
                .hunger_cost
        ) +
        " HUNGER"
    );

    draw_text(
        _layout.detail_x + 235,
        _cost_y,
        "-" +
        string(
            _selected_recipe
                .hydration_cost
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

    if (sprite_exists(_slot_background))
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
        material_inventory
            .slots[_material_slot];

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
        _layout.material_slot_size - 16;

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
            _layout.material_slot_size - 4,
            _slot_y +
            _layout.material_slot_size - 4,
            string(_slot.amount)
        );
    }
}


// ====================================================================
// CRAFT BUTTON
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

if (craft_button_press_timer > 0)
{
    _button_y += 2;
}

if (sprite_exists(spr_craft_button))
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

if (!_can_craft)
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
else if (_craft_hovered)
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

var _button_text = "";

if (is_crafting)
{
    _button_text = "WORKING";
}
else if (pending_output_amount > 0)
{
    _button_text =
        "OUTPUT WAITING";
}

var _button_text_color =
    craft_ui_disabled_color;

if (_can_craft)
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
        crafting_get_progress(
            craft_start_timestamp,
            craft_finish_timestamp
        );

    if (sprite_exists(spr_progress_bar))
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

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);

    draw_text(
        _layout.progress_x +
        _layout.progress_w * 0.5,
        _layout.progress_y +
        _layout.progress_h * 0.5,
        string(
            floor(_progress * 100)
        ) +
        "%"
    );
}


// ====================================================================
// COMPLETION FLASH
// ====================================================================

if (craft_complete_flash_timer > 0)
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