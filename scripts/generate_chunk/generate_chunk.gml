function generate_chunk(_cx, _cy)
{
    var key = string(_cx) + "_" + string(_cy);

    if (ds_map_exists(generated_chunks, key))
    {
        return;
    }

    ds_map_add(generated_chunks, key, true);

    var chunk_x = _cx * chunk_size;
    var chunk_y = _cy * chunk_size;

    // Generate stones
    for (var i = 0; i < stones_per_chunk; i++)
    {
        var px = chunk_x + irandom(chunk_size - 1);
        var py = chunk_y + irandom(chunk_size - 1);

        spawn_on_land(px, py, obj_stone);
    }

    // Generate trees
    for (var i = 0; i < trees_per_chunk; i++)
    {
        var px = chunk_x + irandom(chunk_size - 1);
        var py = chunk_y + irandom(chunk_size - 1);

        spawn_on_land(px, py, obj_dead_narra);
    }
	
	    for (var i = 0; i < trees_per_chunk; i++)
    {
        var px = chunk_x + irandom(chunk_size - 1);
        var py = chunk_y + irandom(chunk_size - 1);

        spawn_on_land(px, py, obj_dead_2);
    }

    // Generate grass
    for (var i = 0; i < grass_per_chunk; i++)
    {
        var px = chunk_x + irandom(chunk_size - 1);
        var py = chunk_y + irandom(chunk_size - 1);

        spawn_on_land(px, py, obj_dry_grass);
    }
	

}