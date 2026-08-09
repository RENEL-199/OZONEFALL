event_inherited()

sprite_index = spr_composter;
image_index = 0;
image_speed = 0;

depth = -bbox_bottom;


interaction_range = 32;
interaction_key = ord("E");

can_interact = false;


// Capacity and processing
material_capacity = 20;
stored_materials = 0;

processing_duration_minutes =
    10;

processing_start_timestamp = 0;
processing_finish_timestamp = 0;

is_processing = false;

output_item_id =
    ItemID.Compost;

output_amount = 1;


// One interaction deposits up to this amount.
maximum_deposit_per_interaction = 1;


// Any mixture of these items is accepted.
accepted_materials =
[
    ItemID.Spoiled_carrot,
    ItemID.Stick,
    ItemID.Green_fiber
];


// Feedback
message = "";
message_timer = 0;

completion_pulse_timer = 0;

prompt_text_scale = 0.50;


// Colors
progress_background_color =
    make_color_rgb(
        35,
        31,
        27
    );

fill_progress_color =
    make_color_rgb(
        121,
        91,
        51
    );

processing_progress_color =
    make_color_rgb(
        103,
        151,
        72
    );

message_color =
    make_color_rgb(
        226,
        215,
        187
    );


set_message = function(
    _text,
    _duration = 150
)
{
    message = _text;

    message_timer =
        max(
            1,
            _duration
        );
};


is_material_accepted = function(
    _item_id
)
{
    var _accepted_count =
        array_length(
            accepted_materials
        );

    for (
        var _i = 0;
        _i < _accepted_count;
        _i++
    )
    {
        if (
            accepted_materials[_i] ==
            _item_id
        )
        {
            return true;
        }
    }

    return false;
};


update_visual_state = function()
{
    if (
        is_processing ||
        stored_materials >=
        material_capacity
    )
    {
        image_index = 2;
    }
    else if (stored_materials > 0)
    {
        image_index = 1;
    }
    else
    {
        image_index = 0;
    }
};


get_processing_progress = function()
{
    if (!is_processing)
    {
        return 0;
    }

    if (
        !variable_global_exists(
            "game_time"
        )
    )
    {
        return 0;
    }

    var _duration =
        processing_finish_timestamp -
        processing_start_timestamp;

    if (_duration <= 0)
    {
        return 1;
    }

    var _elapsed =
        global.game_time.get_timestamp() -
        processing_start_timestamp;

    return clamp(
        _elapsed / _duration,
        0,
        1
    );
};


start_processing = function()
{
    if (is_processing)
    {
        return false;
    }

    if (
        stored_materials <
        material_capacity
    )
    {
        return false;
    }

    if (
        !variable_global_exists(
            "game_time"
        )
    )
    {
        set_message(
            "The game clock is unavailable."
        );

        return false;
    }

    processing_start_timestamp =
        global.game_time.get_timestamp();

    processing_finish_timestamp =
        global.game_time.create_timestamp(
            processing_duration_minutes
        );

    is_processing = true;

    update_visual_state();

    set_message(
        "",
        180
    );

    return true;
};


deposit_selected_material = function()
{
    if (is_processing)
    {
        set_message(
            ""
        );

        return false;
    }

    if (
        !variable_global_exists(
            "player_inventory"
        ) ||
        !variable_global_exists(
            "hotbar_selected"
        )
    )
    {
        return false;
    }

    var _inventory =
        global.player_inventory;

    var _slot_index =
        global.hotbar_selected;

    if (
        !_inventory.is_valid_slot(
            _slot_index
        )
    )
    {
        return false;
    }

    var _slot =
        _inventory.slots[
            _slot_index
        ];

    if (
        is_undefined(_slot) ||
        _slot.is_empty()
    )
    {
        set_message(
            ""
        );

        return false;
    }

    var _item_id =
        _slot.item_id;

    if (
        !is_material_accepted(
            _item_id
        )
    )
    {
        set_message(
            ""
        );

        return false;
    }

    var _space_remaining =
        material_capacity -
        stored_materials;

    if (_space_remaining <= 0)
    {
        start_processing();
        return false;
    }

    var _deposit_amount =
        min(
            _space_remaining,
            min(
                _slot.amount,
                maximum_deposit_per_interaction
            )
        );

    if (_deposit_amount <= 0)
    {
        return false;
    }

    var _remaining =
        _inventory.remove_item(
            _item_id,
            _deposit_amount
        );

    var _removed_amount =
        _deposit_amount -
        _remaining;

    if (_removed_amount <= 0)
    {
        return false;
    }

    stored_materials +=
        _removed_amount;

    stored_materials =
        clamp(
            stored_materials,
            0,
            material_capacity
        );


    var _item_data =
        item_get_data(
            _item_id
        );

    var _item_name =
        "material";

    if (!is_undefined(_item_data))
    {
        _item_name =
            _item_data.name;
    }

   
  

    update_visual_state();

    if (
        stored_materials >=
        material_capacity
    )
    {
        start_processing();
    }

    return true;
};


complete_processing = function()
{
    if (!is_processing)
    {
        return false;
    }

    resource_drop_item(
        output_item_id,
        output_amount,
        x,
        bbox_bottom,
        14
    );

    stored_materials = 0;

    is_processing = false;

    processing_start_timestamp = 0;
    processing_finish_timestamp = 0;

    completion_pulse_timer = 35;

    update_visual_state();

    set_message(
        "Compost is ready!",
        210
    );


    repeat (4)
    {
        effect_create_above(
            ef_spark,
            x +
            irandom_range(-8, 8),
            bbox_bottom -
            irandom_range(5, 17),
            0.15,
            choose(
                make_color_rgb(
                    116,
                    154,
                    74
                ),

                make_color_rgb(
                    139,
                    101,
                    58
                )
            )
        );
    }

    return true;
};


update_visual_state();