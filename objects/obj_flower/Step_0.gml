event_inherited();

// ---- Proximity sway effect ----
var dist = point_distance(x, y, obj_player.x, obj_player.y);

if (dist < 32) {
    sway_strength = (32 - dist) / 32;
} else {
    sway_strength = max(sway_strength - 0.02, 0); // Ease out
}

sway += sway_speed;



// ---- Depth sorting ----
depth = -y;
