/// obj_restoration_controller — Step Event

if (
    ground_tilemap_id == -1 ||
    !variable_global_exists("game_time")
)
{
    exit;
}

var _tile_budget =
    maximum_tiles_per_step;


// Work backward so invalid sources can be removed safely.
for (
    var _i =
        array_length(
            restoration_sources
        ) - 1;

    _i >= 0;
    _i--
)
{
    var _source =
        restoration_sources[_i];


    // Remove restoration sources whose trees were chopped.
    if (!instance_exists(_source.tree_id))
    {
        array_delete(
            restoration_sources,
            _i,
            1
        );

        continue;
    }


    if (_source.completed)
    {
        continue;
    }


    // Process overdue restoration while respecting the frame budget.
    while (
        _tile_budget > 0 &&
        !_source.completed &&
        global.game_time.timestamp_reached(
            _source.next_restore_timestamp
        )
    )
    {
        var _restored =
            restore_next_tile(
                _source
            );

        if (_restored)
        {
            _tile_budget--;
        }


        // Use the previous scheduled time so sleeping and skipped
        // time can catch up without changing the restoration rate.
        _source.next_restore_timestamp +=
            minutes_per_tile;


        if (!_restored)
        {
            break;
        }
    }


    if (_tile_budget <= 0)
    {
        break;
    }
}