function spawn_on_land(_x, _y, _obj)
{
    if (_x < 0 || _y < 0 || _x >= room_width || _y >= room_height)
    {
        return noone;
    }

    var tx = floor(_x / tile_w);
    var ty = floor(_y / tile_h);

    var final_x = tx * tile_w;
    var final_y = ty * tile_h;

    var tile = tilemap_get_at_pixel(tilemap_id, final_x, final_y);
    var tile_index = tile & tile_index_mask;

    if (tile_index == LAND_TILE_INDEX)
    {
        return instance_create_layer(final_x, final_y, "Instances_1", _obj);
    }

    return noone;
}