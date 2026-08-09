/// TreeHarvestSystem.gml


function TreeHarvestDrop(
    _item_id,
    _minimum_amount,
    _maximum_amount,
    _drop_chance = 1
)
constructor
{
    item_id = _item_id;

    minimum_amount =
        max(1, floor(_minimum_amount));

    maximum_amount =
        max(
            minimum_amount,
            floor(_maximum_amount)
        );

    drop_chance =
        clamp(_drop_chance, 0, 1);
}


// ====================================================================
// INITIALIZE HARVESTABLE TREE
// ====================================================================
function tree_harvest_initialize(
    _tree,
    _maximum_hits,
    _loot,
    _required_tool_id = ItemID.Axe
)
{
    if (!instance_exists(_tree))
    {
        return false;
    }

    _tree.harvest_enabled = true;

    _tree.maximum_hits =
        max(1, floor(_maximum_hits));

    _tree.current_hits = 0;

    _tree.harvest_loot =
        _loot;

    _tree.required_tool_id =
        _required_tool_id;

    _tree.interaction_range = 38;
    _tree.interaction_key = ord("E");

    _tree.can_chop = false;
    _tree.has_required_tool = false;

    _tree.tree_destroyed = false;

    _tree.hit_flash_duration = 6;
    _tree.hit_flash_timer = 0;

    _tree.hit_shake_duration = 6;
    _tree.hit_shake_timer = 0;

    _tree.hit_shake_amount = 1;

    return true;
}


// ====================================================================
// DROP LOOT
// ====================================================================
function tree_harvest_drop_loot(_tree)
{
    if (!instance_exists(_tree))
    {
        return false;
    }

    var _drop_x =
        _tree.x;

    var _drop_y =
        _tree.bbox_bottom;

    var _loot_count =
        array_length(
            _tree.harvest_loot
        );

    for (
        var _i = 0;
        _i < _loot_count;
        _i++
    )
    {
        var _drop =
            _tree.harvest_loot[_i];

        if (
            random(1) <=
            _drop.drop_chance
        )
        {
            var _amount =
                irandom_range(
                    _drop.minimum_amount,
                    _drop.maximum_amount
                );

            resource_drop_item(
                _drop.item_id,
                _amount,
                _drop_x,
                _drop_y,
                16
            );
        }
    }

    return true;
}


// ====================================================================
// CHOP TREE
// ====================================================================
function tree_harvest_take_hit(_tree)
{
    if (
        !instance_exists(_tree) ||
        _tree.tree_destroyed
    )
    {
        return false;
    }

    // Protect the hit function against calls from other objects.
    if (
        !variable_instance_exists(
            _tree,
            "required_tool_id"
        )
    )
    {
        return false;
    }

    if (
        !hotbar_has_selected_item(
            _tree.required_tool_id
        )
    )
    {
        return false;
    }

    _tree.current_hits++;

    _tree.hit_flash_timer =
        _tree.hit_flash_duration;

    _tree.hit_shake_timer =
        _tree.hit_shake_duration;

    if (
        _tree.current_hits >=
        _tree.maximum_hits
    )
    {
        _tree.tree_destroyed = true;

        tree_harvest_drop_loot(
            _tree
        );

        with (_tree)
        {
            instance_destroy();
        }
    }

    return true;
}


// ====================================================================
// UPDATE TREE INTERACTION
// ====================================================================
function tree_harvest_update(_tree)
{
    if (!instance_exists(_tree))
    {
        return false;
    }

    _tree.can_chop = false;
    _tree.has_required_tool = false;

    if (_tree.hit_flash_timer > 0)
    {
        _tree.hit_flash_timer--;
    }

    if (_tree.hit_shake_timer > 0)
    {
        _tree.hit_shake_timer--;
    }

    var _player =
        instance_find(obj_player, 0);

    if (!instance_exists(_player))
    {
        return false;
    }

    if (
        !variable_instance_exists(
            _tree,
            "required_tool_id"
        )
    )
    {
        return false;
    }

    _tree.has_required_tool =
        hotbar_has_selected_item(
            _tree.required_tool_id
        );

    var _distance =
        point_distance(
            _tree.x,
            _tree.bbox_bottom,
            _player.x,
            _player.bbox_bottom
        );

    // Only the nearest tree can receive this E press.
    var _nearest_tree =
        instance_nearest(
            _player.x,
            _player.y,
            obj_harvestable_tree_parent
        );

    _tree.can_chop =
        _tree.has_required_tool &&
        _distance <= _tree.interaction_range &&
        _nearest_tree == _tree.id;

    if (
        _tree.can_chop &&
        keyboard_check_pressed(
            _tree.interaction_key
        )
    )
    {
        tree_harvest_take_hit(
            _tree
        );
    }

    return true;
}


// ====================================================================
// DRAW TREE AND FEEDBACK
// ====================================================================
function tree_harvest_draw(_tree)
{
    if (!instance_exists(_tree))
    {
        return;
    }

    var _shake_x = 0;

    if (_tree.hit_shake_timer > 0)
    {
        _shake_x =
            choose(
                -_tree.hit_shake_amount,
                _tree.hit_shake_amount
            );
    }

    var _flash_amount = 0;

    if (_tree.hit_flash_timer > 0)
    {
        _flash_amount =
            _tree.hit_flash_timer /
            max(
                1,
                _tree.hit_flash_duration
            );
    }

    var _sway_strength = 0.7;
    var _sway_speed = 0.8;

    if (
        variable_instance_exists(
            _tree,
            "sway_strength"
        )
    )
    {
        _sway_strength =
            _tree.sway_strength;
    }

    if (
        variable_instance_exists(
            _tree,
            "sway_speed"
        )
    )
    {
        _sway_speed =
            _tree.sway_speed;
    }

    tree_shadow_draw(
        _tree
    );

    vegetation_sway_draw(
        _tree,
        _sway_strength,
        _sway_speed,
        _flash_amount,
        _shake_x
    );

    shader_reset();

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_set_alpha(1);
}