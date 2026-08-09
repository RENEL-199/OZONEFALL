enum CampfireRecipeID
{
    PurifyWater = 0,
    BerryKebab  = 1,
    LagundiTea  = 2
}


function campfire_recipe_database_create()
{
    global.campfire_recipes = [];


    global.campfire_recipes[
        CampfireRecipeID.PurifyWater
    ] = new CraftingRecipe(
        "Purify Water",
        ItemID.Clean_water_bottle,
        1,

        [
            new CraftingIngredient(
                ItemID.Dirty_water_bottle,
                1
            )
        ],

        30,
        0,
        0
    );


    global.campfire_recipes[
        CampfireRecipeID.BerryKebab
    ] = new CraftingRecipe(
        "Wild Berry Kebab",
        ItemID.Wild_berry_kebab,
        1,

        [
            new CraftingIngredient(
                ItemID.Wild_berry,
                3
            ),

            new CraftingIngredient(
                ItemID.Stick,
                1
            )
        ],

        20,
        0,
        0
    );


    global.campfire_recipes[
        CampfireRecipeID.LagundiTea
    ] = new CraftingRecipe(
        "Lagundi Tea",
        ItemID.Lagundi_tea,
        1,

        [
            new CraftingIngredient(
                ItemID.Lagundi,
                2
            ),

            new CraftingIngredient(
                ItemID.Clean_water_bottle,
                1
            )
        ],

        30,
        0,
        0
    );
}


function campfire_recipe_get(_recipe_id)
{
    if (
        !variable_global_exists(
            "campfire_recipes"
        )
    )
    {
        return undefined;
    }

    if (
        _recipe_id < 0 ||
        _recipe_id >=
        array_length(
            global.campfire_recipes
        )
    )
    {
        return undefined;
    }

    return global.campfire_recipes[
        _recipe_id
    ];
}