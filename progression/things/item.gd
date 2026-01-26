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


func is_strictly_better(item: CraftedItem) -> bool:
	# returns true if this item has any stat better and all equal or better
	# otherwise (if a stat is worse or all stats are equal) returns false
	if not item:
		# comparing with nothing (null)
		return true
	for stat in item.stats:
		if stat not in stats or item.stats[stat] > stats[stat]:
			return false # other item has a better stat
	# now we know this item is not worse, we check if it's better
	for stat in stats:
		if stat not in item.stats or item.stats[stat] < stats[stat]:
			return true
	# items have same stats
	return true
