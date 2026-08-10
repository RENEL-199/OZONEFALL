
enum ItemID
{
    None     = -1,
    Bandages = 0,
    Stone    = 1,
	Canned_sardines = 2,
	Log = 3,
	Split_log =4,
	Stick = 5,
	Campfire = 6,
	Narra_seed = 7,
	Green_fiber = 8,
	Lagundi =9,
	Scyte = 10,
	Axe = 11,
	Clean_water_bottle = 12,
	Dirty_water_bottle = 13,
	Empty_water_bottle =14,
	Lagundi_tea = 15,
	Wild_berry = 16,
	Wild_berry_kebab = 17,
	balete_seed = 18,
	Spoiled_carrot = 19,
	Compost = 20,
	Metal_scrap = 21,
	Composter = 22,
	Watering_Can = 23,
	Hoe = 24,
	Pumpkin_seed = 25,
	Pumpkin = 26
}


function ItemData(
    _name,
    _sprite,
    _max_stack = 99,
    _description = "",
    _can_use = undefined,
    _use_effect = undefined,
    _placement = undefined,
    _use_replacement_item_id = ItemID.None
)
constructor
{
    name = _name;
    sprite = _sprite;

    max_stack =
        max(
            1,
            _max_stack
        );

    description =
        _description;

    can_use =
        _can_use;

    use_effect =
        _use_effect;

    placement =
        _placement;

    use_replacement_item_id =
        _use_replacement_item_id;
}


function ItemPlacementData(
    _object,
    _preview_sprite,
    _placement_data = undefined
)
constructor
{
    object = _object;

    preview_sprite =
        _preview_sprite;

    placement_data =
        _placement_data;
}



function item_database_create()
{
    global.item_database = [];

    // ================================================================
    // BANDAGES
    // ================================================================
    global.item_database[ItemID.Bandages] = new ItemData(
        "Bandages",
        spr_bandages,
        99,
        "A clean bandage that restores 25 Vitality.",

        // Check whether the item can currently be used.
        function(_survival)
        {
            if (_survival.is_dead) {
                return false;
            }

            return _survival.vitality < _survival.max_vitality;
        },

        // Apply the item effect.
        function(_survival)
        {
            _survival.heal(25);
            return true;
        }
    );
	
	global.item_database[ItemID.Canned_sardines] = new ItemData(
	
	"Canned_sardines",
	Sprite61,
	10,
	"Canned Sardines, 'I dont know if its expired or not, gotta eat sumthing though'. Restore 25 Hunger.",
	
	function(_survival)
	{
		if (_survival.is_dead) {
			return false;
		}
		
		return _survival.hunger < _survival.max_hunger;
	},
	
	function(_survival)
	{
		_survival.add_hunger(25);
		return true;
	}
	);
	
	
		global.item_database[ItemID.Pumpkin] =
    new ItemData(
        "Pumpkin",
        Sprite114,
        10,
        "A Pumpkin. Restores 15 Hunger but adds 10 Toxicity.",

        function(_survival)
        {
            if (_survival.is_dead)
            {
                return false;
            }

            return
                _survival.hunger <
                _survival.max_hunger;
        },

        function(_survival)
        {
            _survival.add_hunger(15);
            _survival.add_toxicity(10);

            return true;
        }
    );
	
	
	global.item_database[ItemID.Wild_berry] =
    new ItemData(
        "Wild Berry",
        spr_wild_berry,
        10,
        "An unfamiliar wild berry. Restores 5 Hunger but adds 5 Toxicity.",

        function(_survival)
        {
            if (_survival.is_dead)
            {
                return false;
            }

            return
                _survival.hunger <
                _survival.max_hunger;
        },

        function(_survival)
        {
            _survival.add_hunger(5);
            _survival.add_toxicity(5);

            return true;
        }
    );
	
	
	global.item_database[ItemID.Wild_berry_kebab] = new ItemData(
	"Wild Berry Kebab",
	spr_wild_berry_cooked,
	10,
	"This looks apetizing.... hmmm",
	
	function(_survival)
	{
		if (_survival.is_dead) {
			return false;
		}
		
		return _survival.hunger < _survival.max_hunger;
	},
	
	function(_survival)
	{
		_survival.add_hunger(25);
		return true;
	}
	);
	
	
	
	
	
	
	
global.item_database[
    ItemID.Clean_water_bottle
] = new ItemData(
    "Clean Water Bottle",
    spr_water_bottle_clean,
    10,
    "A bottle containing 100 clean water. Restores 50 Hydration.",

    function(_survival)
    {
        if (_survival.is_dead)
        {
            return false;
        }

        return
            _survival.hydration <
            _survival.max_hydration;
    },

    function(_survival)
    {
        _survival.add_hydration(50);
        return true;
    },

    undefined,

    ItemID.Empty_water_bottle
);
	
	
	
	
global.item_database[
    ItemID.Dirty_water_bottle
] = new ItemData(
    "Dirty Water Bottle",
    spr_water_bottle_dirty,
    10,
    "A bottle containing 100 dirty water. Restores 50 Hydration but adds 10 Toxicity.",

    function(_survival)
    {
        if (_survival.is_dead)
        {
            return false;
        }

        return
            _survival.hydration <
            _survival.max_hydration &&
            _survival.toxicity <
            _survival.max_toxicity;
    },

    function(_survival)
    {
        _survival.add_hydration(50);
        _survival.add_toxicity(10);

        return true;
    },

    undefined,

    ItemID.Empty_water_bottle
);
	
	
		global.item_database[ItemID.Lagundi] = new ItemData(
	
	"Lagundi",
	spr_lagundi,
	20,
	"A Plant known for its medicinal properties, 'My Lola always drinks Lagundi tea when i was young, she says it has some detoxifying properties' ",
	
	function(_survival)
	{
		if (_survival.is_dead) {
			return false;
		}
		
		return _survival.toxicity < _survival.max_toxicity;
	},
	
	function(_survival)
	{
		_survival.add_toxicity(-5);
		return true;
	}
	);
	
	
			global.item_database[ItemID.Lagundi_tea] = new ItemData(
	
	"Lagundi Tea",
	spr_lagundi_tea,
	20,
	"SOOO!!! Relaxing.... but bitter",
	
	function(_survival)
	{
		if (_survival.is_dead) {
			return false;
		}
		
		return _survival.toxicity < _survival.max_toxicity;
	},
	
	function(_survival)
	{
		_survival.add_toxicity(-25);
		return true;
	}
	);

    // ================================================================
    // No use behavior. MATERIALS
    // ================================================================
	    global.item_database[ItemID.Metal_scrap] = new ItemData(
        "Meatl Scrap",
        spr_metal_scrap,
        20,
        "A rusty metal scrap. Hope I wont get Tetanus."
    );
	
	
	
    global.item_database[ItemID.Stone] = new ItemData(
        "Stone",
        spr_stones,
        99,
        "A small stone."
    );
	
	    global.item_database[ItemID.Log] = new ItemData(
        "Log",
        spr_log,
        99,
        "The most precious thing in the Universe, Yet unvaliable."
    );
	
		    global.item_database[ItemID.Split_log] = new ItemData(
        "Planks",
        spr_split_log,
        99,
        "The most precious thing in the Universe, just cut into pieces"
    );
	
		global.item_database[ItemID.Stick] = new ItemData(
        "Stick",
        spr_stick,
        99,
        "Stick...."
    );
	
	global.item_database[ItemID.Green_fiber] = new ItemData(
        "Fiber",
        spr_green_fiber,
        99,
        "Finally Something Fresh!!"
    );
	
	global.item_database[
    ItemID.Empty_water_bottle] = new ItemData(
    "Empty Water Bottle",
    spr_water_bottle_empty,
    10,
    "An empty bottle capable of holding 100 water."
);
	
	
	
// ================================================================
// Placeable
// ================================================================

global.item_database[ItemID.Campfire] =
    new ItemData(
        "Campfire",
        spr_campfire,
        1,
        "A placeable Campfire. Requires 10 Split Logs to burn for 5 hours.",

        undefined,
        undefined,

        new ItemPlacementData(
            obj_campfire,
            spr_campfire
        )
    );
	
	
	global.item_database[ItemID.Composter] =
    new ItemData(
        "Composter",
        spr_composter,
        1,
        "A Composter. For Farming Yeah Yeah. Smells like...",

        undefined,
        undefined,

        new ItemPlacementData(
            obj_composter,
            spr_composter
        )
    );

	
// ================================================================
// NARRA SEED
// ================================================================
global.item_database[ItemID.Narra_seed] =
    new ItemData(
        "Narra Seed",
        spr_narra_seed,
        99,
        "A Narra seed that can be planted to restore damaged land.",

        undefined,
        undefined,

        new ItemPlacementData(
            obj_narra_1,
            spr_narra_seed
        )
    );
	
	
	global.item_database[ItemID.balete_seed] =
    new ItemData(
        "Balete Seed",
        spr_t2_seed,
        99,
        "A Batlete seed that can be planted to restore damaged land.",

        undefined,
        undefined,

        new ItemPlacementData(
            obj_t2_1,
            spr_t2_seed
        )
    );
	
	// ================================================================
// TOOLS
// 
// ================================================================
global.item_database[ItemID.Scyte] = new ItemData(
    "Scythe",
    spr_scyte,
    1,
    "A tool used to harvest grass and other vegetation."
);

global.item_database[ItemID.Axe] = new ItemData(
    "Axe",
    spr_axe,
    1,
    "A tool used to chop down trees."
);

global.item_database[ItemID.Watering_Can] =
    new ItemData(
        "Watering Can",
        spr_watering_can,
        1,
        "Holds up to 500 water. Each soil watering uses 50 water."
    );


global.item_database[ItemID.Hoe] =
    new ItemData(
        "Hoe",
        spr_hoe,
        1,
        "Used to prepare fertile soil for planting."
    );
	
	
//PRODUCED BY MACHINES	
	
	global.item_database[ItemID.Spoiled_carrot] =
    new ItemData(
        "Spoiled Food",
        spr_spoiled_carrot,
        20,
        "Rotten organic material. It can be processed in a composter."
    );


global.item_database[ItemID.Compost] =
    new ItemData(
        "Compost",

        spr_compost,

        20,

        "Nutrient-rich compost. Place it to create a fertile planting cell.",

        undefined,
        undefined,

        new ItemPlacementData(
            obj_plantable_soil,

            object_get_sprite(
                obj_plantable_soil
            ),

            {
                grid_size   : 16,
                cell_width  : 16,
                cell_height : 16
            }
        )
    );
	
	
	//// SEED ////
	global.item_database[
    ItemID.Pumpkin_seed
] = new ItemData(
    "Pumpkin Seeds",

    spr_seeds,

    99,

    "Pumpkin seeds that can be planted in prepared soil.",

    undefined,
    undefined,

    new ItemPlacementData(
        obj_pumpkin,

        spr_pumpkin_sheet,

        {
            grid_size    : 16,
            cell_width   : 16,
            cell_height  : 16,
            crop_id      : CropID.Pumpkin
        }
    )
);
	
	
	
	
	
	
	
	
	
}




function item_get_data(_item_id)
{
    if (!variable_global_exists("item_database")) {
        return undefined;
    }

    if (_item_id < 0 ||
        _item_id >= array_length(global.item_database)) {
        return undefined;
    }

    return global.item_database[_item_id];
}

/// Returns true if an item can be placed in the world.
function item_is_placeable(_item_id)
{
    var _data =
        item_get_data(_item_id);

    if (is_undefined(_data))
    {
        return false;
    }

    return is_struct(
        _data.placement
    );
}


/// Starts placement for a placeable item.
function item_begin_placement(_item_id)
{
    var _data =
        item_get_data(_item_id);

    if (
        is_undefined(_data) ||
        !is_struct(_data.placement)
    )
    {
        return false;
    }

    return placement_begin(
        _item_id,
        _data.placement.object,
        _data.placement.preview_sprite,
        _data.placement.placement_data
    );
}
/// Returns true when an item has a usable effect.
function item_is_usable(_item_id)
{
    var _data = item_get_data(_item_id);

    if (is_undefined(_data)) {
        return false;
    }

    return !is_undefined(_data.use_effect);
}


/// Returns true when an item's requirements are satisfied.
function item_can_use(_item_id)
{
    if (!variable_global_exists("survival")) {
        return false;
    }

    var _data = item_get_data(_item_id);

    if (is_undefined(_data)) {
        return false;
    }

    if (is_undefined(_data.use_effect)) {
        return false;
    }

    // Items without a condition can always be used.
    if (is_undefined(_data.can_use)) {
        return true;
    }

    return _data.can_use(global.survival);
}


/// Applies an item effect without removing it from the inventory.
function item_use(_item_id)
{
    if (!item_can_use(_item_id)) {
        return false;
    }

    var _data = item_get_data(_item_id);

    return _data.use_effect(global.survival);
}