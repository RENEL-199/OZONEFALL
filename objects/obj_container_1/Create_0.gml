/// obj_container_1 — Create Event

event_inherited();

image_index = irandom_range(0, 2);
image_speed = 0;

interaction_range = 32;
interaction_key = ord("E");

can_open = false;
is_open = false;

// Every chest owns a different inventory struct.
chest_inventory = new Inventory(
    10,
    "Chest"
);