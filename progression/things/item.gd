extends Object

class_name CraftedItem

var image
var item_name # unique name of item, used for loading
var stats = { } # dict with stats modified by item at base rarity
var value: int
var type: int
var tier: int
var rarity: int


func _init(recipe: ItemRecipe, p_rarity: int):
	image = recipe.image
	item_name = recipe.item_name
	stats = recipe.stats
	type = recipe.type
	tier = recipe.tier
	image = recipe.image
	rarity = p_rarity
	for stat in stats:
		stats[stat] = round(stats[stat] * Enums.rarity_stat_mult[p_rarity])
	value = round(recipe.value * Enums.rarity_price_mult[p_rarity])
