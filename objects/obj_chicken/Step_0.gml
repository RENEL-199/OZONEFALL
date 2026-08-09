// -------------------------------
// Movement logic
move_timer--;

if (move_timer <= 0) {
    // Pick a new random direction OR idle
    if (irandom(4) == 0) {
        dir = -1; // idle
    } else {
        dir = irandom(3); // 0–3 directions
    }
    move_timer = irandom_range(60, 120);
}

// -------------------------------
// Apply direction smoothly
var target_xspd = 0;
var target_yspd = 0;

switch (dir) {
    case 0: target_yspd = -speed_walk; sprite_index = spr_chkb; break; // up
    case 1: target_yspd =  speed_walk; sprite_index = spr_chkf; break; // down
    case 2: target_xspd = -speed_walk; sprite_index = spr_chkl; break; // left
    case 3: target_xspd =  speed_walk; sprite_index = spr_chkr; break; // right
    case -1: target_xspd = 0; target_yspd = 0; break; // idle
}

// Smooth transition
xspd = lerp(xspd, target_xspd, 0.1);
yspd = lerp(yspd, target_yspd, 0.1);

// -------------------------------
// Collision movement (wall blocking)
if (place_meeting(x + xspd, y, obj_solid)) {
    while (!place_meeting(x + sign(xspd), y, obj_solid)) {
        x += sign(xspd);
    }
    xspd = 0; // stop movement
}
x += xspd;

if (place_meeting(x, y + yspd, obj_solid)) {
    while (!place_meeting(x, y + sign(yspd), obj_solid)) {
        y += sign(yspd);
    }
    yspd = 0; // stop movement
}
y += yspd;

// -------------------------------
// Animate only when moving
if (abs(xspd) > 0.1 || abs(yspd) > 0.1) {
    image_speed = 0.2;
} else {
    image_speed = 0;
    image_index = 0; // show first frame when idle
}

// -------------------------------
// Depth sorting
depth = -y;
