extends Node

# autoloded as RecipeList

var recipes = { }
var unlocked_recipes = { }


func _ready() -> void:
	# initializes ALL recipes and adds sword to initial unlocks
	recipes["swordT1"] = ItemRecipe.new(preload("res://res/items/Barbarian_icons_22_b.PNG"), "Iron shortsword", { Enums.material_types.IRON: 3 }, { }, { Enums.stats.ATK: 10 }, 10, Enums.ITEM_TYPE.SWORD, 1)
	unlock_recipe("swordT1")


func unlock_recipe(name: String):
	if name in recipes:
		unlocked_recipes[name] = recipes[name]
	else:
		push_error("recipe does not exist: " + name)
