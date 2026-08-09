chunk_size = 512;
generate_radius = 2;

// Stores generated chunks
generated_chunks = ds_map_create();

// Objects per chunk
stones_per_chunk = 8;
trees_per_chunk = 3;
grass_per_chunk = 20;
bunker_per_chunk =1;

// Tilemap
tilemap_id = layer_tilemap_get_id("mask");

// Your land tile index
LAND_TILE_INDEX = 14;

tile_w = tilemap_get_tile_width(tilemap_id);
tile_h = tilemap_get_tile_height(tilemap_id);


