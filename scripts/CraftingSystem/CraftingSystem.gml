/// CraftingSystem.gml

enum RecipeID
{
    Campfire = 0,
    Split_log = 1,
    Scyte = 2,
    Axe = 3,
	Composter = 4

}


function CraftingIngredient(
    _item_id,
    _amount
)
constructor
{
    item_id = _item_id;

    amount =
        max(
            1,
            floor(_amount)
        );
}


function CraftingRecipe(
    _name,
    _output_item_id,
    _output_amount,
    _ingredients,
    _duration_minutes,
    _hunger_cost = 0,
    _hydration_cost = 0
)
constructor
{
    name = _name;
    output_item_id = _output_item_id;

    output_amount =
        max(
            1,
            floor(_output_amount)
        );

    ingredients = _ingredients;

    duration_minutes =
        max(
            1,
            floor(_duration_minutes)
        );

    hunger_cost =
        max(
            0,
            _hunger_cost
        );

    hydration_cost =
        max(
            0,
            _hydration_cost
        );
}


function crafting_recipe_database_create()
{
    global.crafting_recipes = [];


    global.crafting_recipes[
        RecipeID.Campfire
    ] =
        new CraftingRecipe(
            "Campfire",

            ItemID.Campfire,
            1,

            [
                new CraftingIngredient(
                    ItemID.Stone,
                    2
                ),

                new CraftingIngredient(
                    ItemID.Split_log,
                    2
                )
            ],

            30,
            3,
            0
        );


    global.crafting_recipes[
        RecipeID.Split_log
    ] =
        new CraftingRecipe(
            "Split Log",

            ItemID.Split_log,
            4,

            [
                new CraftingIngredient(
                    ItemID.Log,
                    1
                )
            ],

            10,
            3,
            3
        );


    global.crafting_recipes[
        RecipeID.Scyte
    ] =
        new CraftingRecipe(
            "Scyte",

            ItemID.Scyte,
            1,

            [
                new CraftingIngredient(
                    ItemID.Stone,
                    10
                ),

                new CraftingIngredient(
                    ItemID.Split_log,
                    1
                ),

                new CraftingIngredient(
                    ItemID.Green_fiber,
                    5
                )
            ],

            60,
            10,
            5
        );


    global.crafting_recipes[
        RecipeID.Axe
    ] =
        new CraftingRecipe(
            "Axe",

            ItemID.Axe,
            1,

            [
                new CraftingIngredient(
                    ItemID.Stone,
                    15
                ),

                new CraftingIngredient(
                    ItemID.Split_log,
                    2
                ),

                new CraftingIngredient(
                    ItemID.Green_fiber,
                    5
                )
            ],

            60,
            10,
            5
        );
		
		
	 global.crafting_recipes[
        RecipeID.Composter
    ] =
        new CraftingRecipe(
            "Composter",

            ItemID.Composter,
            1,

            [
                new CraftingIngredient(
                    ItemID.Metal_scrap,
                    4
                ),

                new CraftingIngredient(
                    ItemID.Split_log,
                    4
                )
            ],

            60,
            5,
            0
        );
		
		
		
		
}


function crafting_recipe_get(
    _recipe_id
)
{
    if (
        !variable_global_exists(
            "crafting_recipes"
        )
    )
    {
        return undefined;
    }

    if (
        _recipe_id < 0 ||
        _recipe_id >=
        array_length(
            global.crafting_recipes
        )
    )
    {
        return undefined;
    }

    return global.crafting_recipes[
        _recipe_id
    ];
}


function crafting_has_materials(
    _inventory,
    _recipe
)
{
    if (
        !is_struct(_inventory) ||
        !is_struct(_recipe)
    )
    {
        return false;
    }

    var _ingredient_count =
        array_length(
            _recipe.ingredients
        );

    for (
        var _ingredient_index = 0;
        _ingredient_index <
        _ingredient_count;
        _ingredient_index++
    )
    {
        var _ingredient =
            _recipe.ingredients[
                _ingredient_index
            ];

        var _available =
            _inventory.count_item(
                _ingredient.item_id
            );

        if (
            _available <
            _ingredient.amount
        )
        {
            return false;
        }
    }

    return true;
}


function crafting_consume_materials(
    _inventory,
    _recipe
)
{
    if (
        !crafting_has_materials(
            _inventory,
            _recipe
        )
    )
    {
        return false;
    }

    var _ingredient_count =
        array_length(
            _recipe.ingredients
        );

    for (
        var _ingredient_index = 0;
        _ingredient_index <
        _ingredient_count;
        _ingredient_index++
    )
    {
        var _ingredient =
            _recipe.ingredients[
                _ingredient_index
            ];

        var _remaining =
            _inventory.remove_item(
                _ingredient.item_id,
                _ingredient.amount
            );

        if (_remaining > 0)
        {
            show_debug_message(
                "Crafting error: failed to remove required materials."
            );

            return false;
        }
    }

    return true;
}


function crafting_get_progress(
    _start_timestamp,
    _finish_timestamp
)
{
    if (
        !variable_global_exists(
            "game_time"
        )
    )
    {
        return 0;
    }

    var _duration =
        _finish_timestamp -
        _start_timestamp;

    if (_duration <= 0)
    {
        return 1;
    }

    var _elapsed =
        global.game_time
            .get_timestamp() -
        _start_timestamp;

    return clamp(
        _elapsed / _duration,
        0,
        1
    );
}