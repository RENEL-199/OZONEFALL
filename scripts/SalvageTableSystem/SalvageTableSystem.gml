enum SalvageID{

clock_items = 0,
None = 1,
Tv = 2
}

function ItemRequired (
_item_id,
_amount
)
constructor {
	item_id = _item_id;
	amount = max ( 1, floor(_amount)
	);		
}

function Output (
_name,
_item_id,
_amount
)

constructor {
	name = _name;
item_id = _item_id;
	amount = max ( 1, floor(_amount)
	);

}


function SalvageRecipe(
    _name,
    _output,
    _item_required,
    _duration_minutes,
    _hunger_cost = 0,
    _hydration_cost = 0
)
constructor
{
    name = _name;

    output = _output;
    item_required = _item_required;

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
function salvage_recipe_database_create()
{

global.salvage_recipes = []	

global.salvage_recipes[
    SalvageID.clock_items
] =
new SalvageRecipe(

    "Old Clock",

    [
        new Output(
            "Wire",
            ItemID.Wire,
            3
        ),

        new Output(
            "Electronic Part",
            ItemID.Electronic_part,
            1
        )
    ],

    [
        new ItemRequired(
            ItemID.Clock,
            1
        )
    ],

    20,
    3,
    2
);


global.salvage_recipes[
    SalvageID.Tv
] =
new SalvageRecipe(

    "Broken TV",

    [
        new Output(
            "Wire",
            ItemID.Wire,
            5
        ),

        new Output(
            "Electronic Part",
            ItemID.Electronic_part,
            3
        )
    ],

    [
        new ItemRequired(
            ItemID.Tv,
            1
        )
    ],

    20,
    3,
    2
);
	
	
	
}


function salvage_recipe_get (
_recipe_id
)
{
	
	if ( 
	!variable_global_exists( "salvage_recipes" )
	)
	{
		return undefined;
	}
	
	if ( 
	_recipe_id < 0 ||
	_recipe_id >= 
	array_length(global.salvage_recipes)
	)
	
	{return undefined;
	}
	
	return global.salvage_recipes [ _recipe_id ];
}

function salvage_has_materials(
_inventory,
_recipe
)
{
	if ( !is_struct(_inventory)||
	!is_struct(_recipe)
)
{
	return false;
}

var _ingredient_count = array_length(_recipe.item_required);

for ( var _ingredient_index = 0;
_ingredient_index < _ingredient_count;
_ingredient_index++
)
{
	var _ingredient = 
	_recipe.item_required[
	_ingredient_index];
	
	var _available = 
	_inventory.count_item(
	_ingredient.item_id);
	
	if (
	_available < _ingredient.amount)
	{ return false; }
}

return true;
}

function salvage_consume_materials ( _inventory, _recipe)

{ if (
	!salvage_has_materials(_inventory,_recipe))
	{return false;
	}
	
	var _ingredient_count = array_length(_recipe.item_required);
	
	for ( var _ingredient_index = 0;
	_ingredient_index < 
	_ingredient_count;
	_ingredient_index++
	)
	{
		var _ingredient = _recipe.item_required [ _ingredient_index];
		
		var _remaining = _inventory.remove_item
		( _ingredient.item_id,
		_ingredient.amount);
		
		if (_remaining > 0)
		{
			show_debug_message("Salvage error: Failed to remove materials");
			return false;
		}
	}
	return true;
}

function salvage_get_process ( _start_timestamp, _finish_timestamp)
{
	if ( !variable_global_exists("game_time") )
	{
		return 0;
	}
	
	var _duration =
	_finish_timestamp - _start_timestamp;
	
	if (_duration <= 0)
	{return 1;
	}
	
	var _elapsed = global.game_time.get_timestamp()- _start_timestamp;
	
	return clamp(_elapsed/ _duration, 0,1);
	
	
}











