extends Node

# autoloded as CraftingRecipes

var recipes = { }
var unlocked_recipes = { }
var unlocked_types = []


func _ready() -> void:
	# initializes ALL recipes and adds sword and bow to initial unlocks
	recipes["swordT1"] = ItemRecipe.new(preload("res://res/items/Barbarian_icons_22_b.PNG"), "Iron shortsword", { Enums.material_types.IRON: 3 }, { }, { Enums.stats.ATK: 10 }, 10, Enums.ITEM_TYPE.SWORD, 1)
	unlock_recipe("swordT1")
	recipes["bowT1"] = ItemRecipe.new(preload("res://res/items/Barbarian_icons_116_b.png"), "Shortbow", { Enums.material_types.WOOD: 2, Enums.material_types.IRON: 1 }, { }, { Enums.stats.ATK: 8, Enums.stats.EVASION: 2 }, 10, Enums.ITEM_TYPE.BOW, 1)
	unlock_recipe("bowT1")


func unlock_recipe(item_name: String):
	if item_name in recipes:
		unlocked_recipes[item_name] = recipes[item_name]
		var type = recipes[item_name].type
		if type not in unlocked_types:
			unlocked_types.append(type)
			unlocked_types.sort()
	else:
		push_error("recipe does not exist: " + name)


func get_unlocked_recipes():
	return unlocked_recipes.values()
