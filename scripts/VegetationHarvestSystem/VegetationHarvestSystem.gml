/// VegetationHarvestSystem.gml


// ====================================================================
// GET THE SELECTED HOTBAR ITEM
// ====================================================================
function hotbar_get_selected_item_id()
{
    if (!variable_global_exists("player_inventory"))
    {
        return ItemID.None;
    }

    if (!variable_global_exists("hotbar_selected"))
    {
        return ItemID.None;
    }

    var _inventory =
        global.player_inventory;

    var _slot_index =
        global.hotbar_selected;

    if (!is_struct(_inventory))
    {
        return ItemID.None;
    }

    if (
        _slot_index < 0 ||
        _slot_index >= _inventory.size
    )
    {
        return ItemID.None;
    }

    var _slot =
        _inventory.slots[_slot_index];

    if (
        is_undefined(_slot) ||
        _slot.item_id == ItemID.None ||
        _slot.amount <= 0
    )
    {
        return ItemID.None;
    }

    return _slot.item_id;
}


// ====================================================================
// CHECK THE SELECTED HOTBAR TOOL
// ====================================================================
function hotbar_has_selected_item(_item_id)
{
    return hotbar_get_selected_item_id()
        == _item_id;
}


// ====================================================================
// FIND THE NEAREST VEGETATION
//
// This prevents several nearby plants from being harvested by one
// press of the E key.
// ====================================================================
function vegetation_find_nearest(_player)
{
    if (!instance_exists(_player))
    {
        return noone;
    }

    var _nearest =
        noone;

    var _nearest_distance =
        1000000;

    var _count =
        instance_number(
            obj_harvestable_vegetation_parent
        );

    for (var _i = 0; _i < _count; _i++)
    {
        var _plant =
            instance_find(
                obj_harvestable_vegetation_parent,
                _i
            );

        if (!instance_exists(_plant))
        {
            continue;
        }

        var _distance =
            point_distance(
                _player.x,
                _player.y,
                _plant.x,
                _plant.y
            );

        if (
            _distance <= _plant.harvest_range &&
            _distance < _nearest_distance
        )
        {
            _nearest =
                _plant;

            _nearest_distance =
                _distance;
        }
    }

    return _nearest;
}


// ====================================================================
// CREATE THE WORLD PICKUP
// ====================================================================
function vegetation_create_drop(
    _plant,
    _item_id,
    _amount
)
{
    if (!instance_exists(_plant))
    {
        return noone;
    }

    if (
        _item_id == ItemID.None ||
        _amount <= 0
    )
    {
        return noone;
    }

    var _item_data =
        item_get_data(_item_id);

    if (is_undefined(_item_data))
    {
        return noone;
    }

    var _drop_x =
        _plant.x +
        irandom_range(-4, 4);

    var _drop_y =
        _plant.bbox_bottom +
        irandom_range(-2, 3);

    // Using depth avoids depending on a named instance layer.
    var _drop =
        instance_create_depth(
            _drop_x,
            _drop_y,
            -_drop_y * 2,
            obj_pickup_parent
        );

    if (!instance_exists(_drop))
    {
        return noone;
    }

    // Use the pickup parent's reusable setup method when available.
    if (
        variable_instance_exists(
            _drop,
            "setup_item"
        )
    )
    {
        _drop.setup_item(
            _item_id,
            _amount
        );
    }
    else
    {
        // Compatibility fallback.
        _drop.item_id =
            _item_id;

        _drop.amount =
            _amount;

        _drop.sprite_index =
            _item_data.sprite;

        _drop.image_index = 0;
        _drop.image_speed = 0;
    }

    _drop.depth =
        -_drop.bbox_bottom * 2;

    return _drop;
}


// ====================================================================
// HARVEST PARTICLES
//
// Built-in effects manage their own particles and cleanup.
// ====================================================================
function vegetation_create_particles(
    _x,
    _y
)
{
    var _dark_green =
        make_color_rgb(55, 107, 61);

    var _light_green =
        make_color_rgb(109, 153, 72);

    repeat (4)
    {
        effect_create_above(
            ef_spark,
            _x + irandom_range(-5, 5),
            _y + irandom_range(-3, 3),
            0.15,
            choose(
                _dark_green,
                _light_green
            )
        );
    }
}


// ====================================================================
// HARVEST A VEGETATION INSTANCE
// ====================================================================
function vegetation_harvest(_plant)
{
    if (!instance_exists(_plant))
    {
        return false;
    }

    if (
        !hotbar_has_selected_item(
            _plant.required_tool_id
        )
    )
    {
        return false;
    }

    var _drop =
        vegetation_create_drop(
            _plant,
            _plant.harvest_item_id,
            _plant.harvest_amount
        );

    // Do not destroy the plant if its pickup could not be created.
    if (!instance_exists(_drop))
    {
        return false;
    }

    vegetation_create_particles(
        _plant.x,
        _plant.bbox_bottom
    );

    with (_plant)
    {
        instance_destroy();
    }

    return true;
}