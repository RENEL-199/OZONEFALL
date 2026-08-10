function player_say(
    _message,
    _duration_ms = 1800
)
{
    if (
        !is_string(_message) ||
        string_length(_message) <= 0
    )
    {
        return false;
    }

    var _bubble =
        instance_find(
            obj_player_speech_bubble,
            0
        );

    if (!instance_exists(_bubble))
    {
        _bubble =
            instance_create_depth(
                0,
                0,
                -1000000,
                obj_player_speech_bubble
            );
    }

    if (!instance_exists(_bubble))
    {
        return false;
    }

    _bubble.set_bubble_message(
        _message,
        _duration_ms
    );

    return true;
}