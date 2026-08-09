/// InventorySettingsUI.gml

function inventory_ui_get_settings_layout(
    _ui,
    _base_layout
)
{
    var _page_x =
        _base_layout.grid_x;

    var _page_width =
        _base_layout.description_w;

    var _page_y =
        _base_layout.panel_y +
        _ui.title_height +
        24;

    var _slot_height = 110;

    var _button_width = min(
        _ui.settings_button_width,
        _page_width
    );

    var _button_x =
        _page_x +
        (
            _page_width -
            _button_width
        ) * 0.5;

    var _save_y =
        _page_y +
        _slot_height +
        _ui.settings_section_gap;

    var _load_y =
        _save_y +
        _ui.settings_button_height +
        _ui.settings_button_gap;

    return {
        page_x: _page_x,
        page_y: _page_y,
        page_w: _page_width,

        slot_x: _page_x,
        slot_y: _page_y,
        slot_w: _page_width,
        slot_h: _slot_height,

        save_x: _button_x,
        save_y: _save_y,

        load_x: _button_x,
        load_y: _load_y,

        button_w: _button_width,
        button_h:
            _ui.settings_button_height
    };
}