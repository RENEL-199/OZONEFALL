function gameplay_input_is_locked()
{
    if (
        !variable_global_exists(
            "gameplay_lock_owner"
        )
    )
    {
        return false;
    }

    var _owner =
        global.gameplay_lock_owner;

    if (!instance_exists(_owner))
    {
        global.gameplay_lock_owner =
            noone;

        return false;
    }

    if (
        !variable_instance_exists(
            _owner,
            "is_crafting"
        )
    )
    {
        global.gameplay_lock_owner =
            noone;

        return false;
    }

    return _owner.is_crafting;
}