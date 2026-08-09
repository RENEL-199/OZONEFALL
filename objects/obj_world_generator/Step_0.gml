if (!instance_exists(obj_player)) exit;

var player_chunk_x = floor(obj_player.x / chunk_size);
var player_chunk_y = floor(obj_player.y / chunk_size);

for (var cx = player_chunk_x - generate_radius; cx <= player_chunk_x + generate_radius; cx++)
{
    for (var cy = player_chunk_y - generate_radius; cy <= player_chunk_y + generate_radius; cy++)
    {
        generate_chunk(cx, cy);
    }
}