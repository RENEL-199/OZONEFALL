/// salvage_ui_get_layout
///
/// Universal crafting / salvage station UI layout.
/// Works with different crafting station objects.
/// Missing station variables automatically use safe defaults.

function salvage_ui_get_layout(
    _ui,
    _table
)
{
    // ====================================================================
    // GUI
    // ====================================================================

    var _gui_width =
        display_get_gui_width();

    var _gui_height =
        display_get_gui_height();


    // ====================================================================
    // SAFE STATION SETTINGS
    // ====================================================================
    //
    // Every value is checked before reading it.
    // This allows different crafting stations to use the same UI system.
    //

    var _margin = 32;

    if (
        variable_instance_exists(
            _table,
            "craft_ui_margin"
        )
    )
    {
        _margin =
            _table.craft_ui_margin;
    }


    var _ui_width = 640;

    if (
        variable_instance_exists(
            _table,
            "craft_ui_width"
        )
    )
    {
        _ui_width =
            _table.craft_ui_width;
    }


    var _ui_height = 520;

    if (
        variable_instance_exists(
            _table,
            "craft_ui_height"
        )
    )
    {
        _ui_height =
            _table.craft_ui_height;
    }


    var _padding = 24;

    if (
        variable_instance_exists(
            _table,
            "craft_ui_padding"
        )
    )
    {
        _padding =
            _table.craft_ui_padding;
    }


    var _header_height = 64;

    if (
        variable_instance_exists(
            _table,
            "craft_ui_header_height"
        )
    )
    {
        _header_height =
            _table.craft_ui_header_height;
    }


    var _list_ratio = 0.45;

    if (
        variable_instance_exists(
            _table,
            "craft_ui_list_ratio"
        )
    )
    {
        _list_ratio =
            _table.craft_ui_list_ratio;
    }


    var _recipe_row_height = 72;

    if (
        variable_instance_exists(
            _table,
            "recipe_row_height"
        )
    )
    {
        _recipe_row_height =
            _table.recipe_row_height;
    }


    var _material_slot_size = 128;

    if (
        variable_instance_exists(
            _table,
            "material_slot_size"
        )
    )
    {
        _material_slot_size =
            _table.material_slot_size;
    }


    var _material_gap = 16;

    if (
        variable_instance_exists(
            _table,
            "material_gap"
        )
    )
    {
        _material_gap =
            _table.material_gap;
    }


    var _material_panel_height = 128;

    if (
        variable_instance_exists(
            _table,
            "material_panel_height"
        )
    )
    {
        _material_panel_height =
            _table.material_panel_height;
    }


    var _craft_button_width = 160;

    if (
        variable_instance_exists(
            _table,
            "craft_button_width"
        )
    )
    {
        _craft_button_width =
            _table.craft_button_width;
    }


    var _craft_button_height = 56;

    if (
        variable_instance_exists(
            _table,
            "craft_button_height"
        )
    )
    {
        _craft_button_height =
            _table.craft_button_height;
    }


    var _progress_bar_height = 20;

    if (
        variable_instance_exists(
            _table,
            "progress_bar_height"
        )
    )
    {
        _progress_bar_height =
            _table.progress_bar_height;
    }


    // ====================================================================
    // RIGHT SIDE LIMIT
    // ====================================================================

    var _right_limit =
        _gui_width -
        _margin;


    if (
        variable_global_exists(
            "player_inventory"
        )
    )
    {
        var _player_layout =
            inventory_ui_get_layout(
                _ui,
                global.player_inventory,
                0,
                true
            );


        _right_limit =
            _player_layout.panel_x -
            (
                variable_instance_exists(
                    _table,
                    "craft_ui_panel_gap"
                )
                ? _table.craft_ui_panel_gap
                : 24
            );
    }


    // ====================================================================
    // PANEL SIZE
    // ====================================================================

    var _available_width =
        max(
            320,
            _right_limit -
            _margin
        );


    var _panel_width =
        min(
            _ui_width,
            _available_width
        );


    var _panel_height =
        min(
            _ui_height,
            _gui_height -
            _margin * 2
        );


    // ====================================================================
    // PANEL POSITION
    // ====================================================================

    var _panel_x =
        _margin;


    var _panel_y =
        max(
            _margin,
            (
                _gui_height -
                _panel_height
            ) * 0.5
        );


    // ====================================================================
    // FOOTER
    // ====================================================================

    var _footer_y =
        _panel_y +
        _panel_height -
        _padding -
        _material_slot_size;


    // ====================================================================
    // CONTENT AREA
    // ====================================================================

    var _content_top =
        _panel_y +
        _padding +
        _header_height;


    var _content_bottom =
        _footer_y -
        28;


    // ====================================================================
    // DIVIDER
    // ====================================================================

    var _divider_x =
        _panel_x +
        floor(
            _panel_width *
            _list_ratio
        );


    // ====================================================================
    // RECIPE LIST
    // ====================================================================

    var _list_x =
        _panel_x +
        _padding;


    var _list_y =
        _content_top;


    var _list_width =
        max(
            120,
            _divider_x -
            _list_x -
            _padding
        );


    var _list_height =
        max(
            _recipe_row_height,
            _content_bottom -
            _list_y
        );


    // ====================================================================
    // RECIPE DETAILS
    // ====================================================================

    var _detail_x =
        _divider_x +
        _padding;


    var _detail_y =
        _content_top;


    var _detail_width =
        max(
            160,
            _panel_x +
            _panel_width -
            _padding -
            _detail_x
        );


    var _detail_height =
        max(
            120,
            _content_bottom -
            _detail_y
        );


    // ====================================================================
    // CRAFT BUTTON
    // ====================================================================

    var _craft_x =
        _panel_x +
        _panel_width -
        _padding -
        _craft_button_width;


    var _craft_y =
        _footer_y +
        (
            _material_slot_size -
            _craft_button_height
        ) * 0.5;


    // ====================================================================
    // PROGRESS BAR
    // ====================================================================

    var _progress_y =
        _content_bottom -
        _progress_bar_height -
        8;


    // ====================================================================
    // MATERIAL SLOT
    // ====================================================================

    var _material_x =
        _list_x;


    var _material_y =
        _footer_y;


    var _material_width =
        _list_width;


    // IMPORTANT:
    // Use the safe local value instead of directly reading
    // _table.material_panel_height.
    //

    var _material_height =
        _material_panel_height;


    // ====================================================================
    // RETURN LAYOUT
    // ====================================================================

    return
    {
        // ---------------------------------------------------------------
        // MAIN PANEL
        // ---------------------------------------------------------------

        panel_x:
            _panel_x,

        panel_y:
            _panel_y,

        panel_w:
            _panel_width,

        panel_h:
            _panel_height,


        // ---------------------------------------------------------------
        // DIVIDER
        // ---------------------------------------------------------------

        divider_x:
            _divider_x,


        // ---------------------------------------------------------------
        // RECIPE LIST
        // ---------------------------------------------------------------

        list_x:
            _list_x,

        list_y:
            _list_y,

        list_w:
            _list_width,

        list_h:
            _list_height,


        // ---------------------------------------------------------------
        // RECIPE DETAILS
        // ---------------------------------------------------------------

        detail_x:
            _detail_x,

        detail_y:
            _detail_y,

        detail_w:
            _detail_width,

        detail_h:
            _detail_height,


        // ---------------------------------------------------------------
        // MATERIAL SLOT
        // ---------------------------------------------------------------

        material_x:
            _material_x,

        material_y:
            _material_y,

        material_w:
            _material_width,

        material_h:
            _material_height,


        material_slot_size:
            _material_slot_size,

        material_gap:
            _material_gap,


        // ---------------------------------------------------------------
        // CRAFT BUTTON
        // ---------------------------------------------------------------

        craft_x:
            _craft_x,

        craft_y:
            _craft_y,

        craft_w:
            _craft_button_width,

        craft_h:
            _craft_button_height,


        // ---------------------------------------------------------------
        // PROGRESS BAR
        // ---------------------------------------------------------------

        progress_x:
            _detail_x,

        progress_y:
            _progress_y,

        progress_w:
            _detail_width,

        progress_h:
            _progress_bar_height
    };
}