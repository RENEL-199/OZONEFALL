function interaction_candidate_is_enabled(
    _candidate
)
{
    if (!instance_exists(_candidate))
    {
        return false;
    }

    if (
        variable_instance_exists(
            _candidate,
            "interaction_enabled"
        ) &&
        !_candidate.interaction_enabled
    )
    {
        return false;
    }

    if (
        variable_instance_exists(
            _candidate,
            "interaction_can_target"
        )
    )
    {
        return
            _candidate.interaction_can_target();
    }

    return true;
}