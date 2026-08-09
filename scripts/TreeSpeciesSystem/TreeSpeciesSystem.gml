/// TreeSpeciesSystem.gml

enum TreeSpeciesID
{
    Narra = 0,
	Balete = 1
	
}


enum TreeGrowthStage
{
    Planted  = 0,
    Juvenile = 1,
    Mature   = 2
}


// ====================================================================
// STAGE-SPECIFIC LOOT
// ====================================================================

function TreeLoot(
    _item_id,
    _minimum_amount,
    _maximum_amount,
    _drop_chance = 1
)
constructor
{
    item_id = _item_id;

    minimum_amount =
        max(1, floor(_minimum_amount));

    maximum_amount =
        max(
            minimum_amount,
            floor(_maximum_amount)
        );

    drop_chance =
        clamp(_drop_chance, 0, 1);
}


// ====================================================================
// TREE SPECIES DATA
// ====================================================================

function TreeSpeciesData(
    _name,
    _seed_item_id,
    _stage_sprites,
    _stage_durations,
    _stage_hits,
    _stage_loot,
    _restoration_radius_tiles,
    _restoration_minutes_per_tile,
    _vegetation
)
constructor
{
    name = _name;

    seed_item_id =
        _seed_item_id;

    stage_sprites =
        _stage_sprites;

    stage_durations =
        _stage_durations;

    stage_hits =
        _stage_hits;

    stage_loot =
        _stage_loot;

    restoration_radius_tiles =
        _restoration_radius_tiles;

    restoration_minutes_per_tile =
        _restoration_minutes_per_tile;

    vegetation =
        _vegetation;
}


// ====================================================================
// CREATE TREE DATABASE
// ====================================================================

function tree_species_database_create()
{
    global.tree_species_database = [];


    // ================================================================
    // NARRA
    // ================================================================

    global.tree_species_database[
        TreeSpeciesID.Narra
    ] = new TreeSpeciesData(
        "Narra",

        ItemID.Narra_seed,

        // Growth-stage sprites
        [
            spr_narra_1,
            spr_narra_2,
            spr_narra_3
        ],

        // Duration of each growing stage.
        // Mature trees do not advance to another stage.
        [
            1440, // Planted → Juvenile: one game day
            1440, // Juvenile → Mature: one game day
            0
        ],

        // Required chopping hits by stage
        [
            1, // Planted
            3, // Juvenile
            5  // Mature
        ],

        // Stage-specific loot
        [
            // Planted
            [
                new TreeLoot(
                    ItemID.Narra_seed,
                    1,
                    1,
                    1
                )
            ],

            // Juvenile
            [
                new TreeLoot(
                    ItemID.Stick,
                    1,
                    2,
                    1
                ),

                new TreeLoot(
                    ItemID.Narra_seed,
                    1,
                    1,
                    0.50
                )
            ],

            // Mature
            [
                new TreeLoot(
                    ItemID.Log,
                    2,
                    4,
                    1
                ),

                new TreeLoot(
                    ItemID.Stick,
                    1,
                    3,
                    1
                ),

                new TreeLoot(
                    ItemID.Narra_seed,
                    1,
                    1,
                    0.25
                )
            ]
        ],

        // Restoration radius
        8,

        // One restored tile every five game hours
        5 * 60,

        // Narra-specific vegetation
        [
            {
                object : obj_wild_berry,
                chance : 0.15
            }
        ]
    );
	
	
	
	
	
	
	
	
	    global.tree_species_database[
        TreeSpeciesID.Balete
    ] = new TreeSpeciesData(
        "Balete",

        ItemID.balete_seed,

        // Growth-stage sprites
        [
            spr_t2_1,
            spr_t2_2,
            spr_t2_3
        ],

        // Duration of each growing stage.
        // Mature trees do not advance to another stage.
        [
            1440, // Planted → Juvenile: one game day
            1440, // Juvenile → Mature: one game day
            0
        ],

        // Required chopping hits by stage
        [
            1, // Planted
            3, // Juvenile
            5  // Mature
        ],

        // Stage-specific loot
        [
            // Planted
            [
                new TreeLoot(
                    ItemID.balete_seed,
                    1,
                    1,
                    1
                )
            ],

            // Juvenile
            [
                new TreeLoot(
                    ItemID.Stick,
                    1,
                    2,
                    1
                ),

                new TreeLoot(
                    ItemID.balete_seed,
                    1,
                    1,
                    0.50
                )
            ],

            // Mature
            [
                new TreeLoot(
                    ItemID.Log,
                    2,
                    4,
                    1
                ),

                new TreeLoot(
                    ItemID.Stick,
                    1,
                    3,
                    1
                ),

                new TreeLoot(
                    ItemID.balete_seed,
                    1,
                    1,
                    0.25
                )
            ]
        ],

        // Restoration radius
        8,

        // One restored tile every five game hours
        5 * 60,

        // Narra-specific vegetation
        [
            {
                object : obj_narra_grass,
                chance : 0.15
            }
        ]
    );
}


// ====================================================================
// GET TREE SPECIES
// ====================================================================

function tree_species_get(_species_id)
{
    if (
        !variable_global_exists(
            "tree_species_database"
        )
    )
    {
        return undefined;
    }

    if (
        _species_id < 0 ||
        _species_id >=
        array_length(
            global.tree_species_database
        )
    )
    {
        return undefined;
    }

    return global.tree_species_database[
        _species_id
    ];
}

function tree_species_get_from_seed(
    _seed_item_id
)
{
    if (
        !variable_global_exists(
            "tree_species_database"
        )
    )
    {
        return undefined;
    }

    var _species_count =
        array_length(
            global.tree_species_database
        );

    for (
        var _i = 0;
        _i < _species_count;
        _i++
    )
    {
        var _species =
            global.tree_species_database[_i];

        if (
            !is_undefined(_species) &&
            _species.seed_item_id ==
            _seed_item_id
        )
        {
            return _species;
        }
    }

    return undefined;
}


function tree_species_is_seed(
    _item_id
)
{
    return !is_undefined(
        tree_species_get_from_seed(
            _item_id
        )
    );
}