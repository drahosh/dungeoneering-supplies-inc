class_name ItemRecipe
extends Object

var image: CompressedTexture2D
var item_name # unique name of item, used for loading
var cost = { } # dict from material to amount
var item_cost = { } # TODO implement, item crafted from one or more items
var stats = { } # dict with stats modified by item at base rarity
var value: int
var type: int # item type Enums.ITEM_TYPE
var tier: int #

var base_rarity: int = Enums.RARITY.COMMON
var crafted_times: int = 0


func _init(
		p_image: CompressedTexture2D,
		p_name: String,
		p_cost: Dictionary,
		p_item_cost: Dictionary,
		p_stats: Dictionary,
		p_value: int,
		p_type: int,
		p_tier: int,
):
	image = p_image
	item_name = p_name
	cost = p_cost
	item_cost = p_item_cost
	stats = p_stats
	value = p_value
	type = p_type
	tier = p_tier


func craftable():
	return Materials.can_afford(cost) # TODO also check for unlock, skill, item_cost


func craft_to_inventory():
	var item = craft()
	if item:
		Inventory.add_item(item)


func craft() -> CraftedItem:
	# Createss item and adds it to inventory
	if not craftable():
		return null
	# TODO pay item_cost
	var rarity = base_rarity
	var rarityUpChance = Enums.baseRarityUpChance * BuildingProgress.get_rarity_up_chance_mult(type)
	while rarity < Enums.RARITY.PERFECT:
		if randf() < rarityUpChance:
			rarity += 1
		else:
			break
	var free_craft_chance = BuildingProgress.get_free_craft_chance(type)
	if randf() >= free_craft_chance:
		Materials.pay_materials(cost)
	return item_from_recipe(rarity)


func item_from_recipe(rarity: Enums.RARITY = Enums.RARITY.COMMON) -> CraftedItem:
	# Used when crafting and loading (items are saved as recipe, rarity, and (TODO) other)
	var item = CraftedItem.new(self, rarity)
	return item
