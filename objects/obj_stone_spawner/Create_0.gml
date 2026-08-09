var tilemap_id = layer_tilemap_get_id("Sand");

// Adjust this index based on your tileset (starts at 0 in the tileset editor)
var LAND_TILE_INDEX = 14;

var total_clusters = 10;
var cluster_radius = 128;
var instances_per_cluster = 4;

var tile_w = tilemap_get_tile_width(tilemap_id);
var tile_h = tilemap_get_tile_height(tilemap_id);



// Track placed grass tiles
if (!variable_global_exists("grass_tiles")) {
    global.grass_tiles = ds_map_create();
}

for (var i = 0; i < total_clusters; i++) {
    var cx = random(room_width);
    var cy = random(room_height);

    for (var j = 0; j < instances_per_cluster; j++) {
        var angle = random(360);
        var dist = random(cluster_radius);
        var ox = lengthdir_x(dist, angle);
        var oy = lengthdir_y(dist, angle);

        var final_x = clamp(cx + ox, 0, room_width - 1);
        var final_y = clamp(cy + oy, 0, room_height - 1);

        // snap to tile grid
        var tx = floor(final_x / tile_w);
        var ty = floor(final_y / tile_h);

        final_x = tx * tile_w;
        final_y = ty * tile_h;

        var tile = tilemap_get_at_pixel(tilemap_id, final_x, final_y);
        var tile_index = tile & tile_index_mask;

        if (tile_index == LAND_TILE_INDEX) {
            // make a unique key for this tile
            var key = string(tx) + "_" + string(ty);

            if (!ds_map_exists(global.grass_tiles, key)) {
                // place grass
                instance_create_layer(final_x, final_y, "Instances_1", obj_stone);

                // mark tile as used
                ds_map_add(global.grass_tiles, key, true);
            }
        }
    }
}
