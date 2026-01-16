class_name Enums
extends Object

#region "materials"
enum material_types {
	IRON,
	WOOD,
}

# shape is used by plugin match3board, used to add resources from matching
static var shape_to_material = {
	"wood": material_types.WOOD,
	"iron_ingot": material_types.IRON,
}
static var base_shape_to_refined_configuration = {
	"iron_ore": preload("res://gathering/pieces/iron_ingot_configuration.tres"),
}
static var material_to_sprite = {
	material_types.IRON: preload("res://res/match/iron_ingot.png"),
	material_types.WOOD: preload("res://res/match/plank.PNG"),
}
#endregion

#region "items"
enum rarity {
	COMMON,
	UNCOMMON,
	RARE,
	LEGENDARY,
	PERFECT,
}
static var rarity_price_mult = {
	rarity.COMMON: 1,
	rarity.UNCOMMON: 1.5,
	rarity.RARE: 2.25,
	rarity.LEGENDARY: 3.5,
	rarity.PERFECT: 6,
}
static var rarity_stat_mult = {
	rarity.COMMON: 1,
	rarity.UNCOMMON: 1.1,
	rarity.RARE: 1.2,
	rarity.LEGENDARY: 1.35,
	rarity.PERFECT: 1.5,
}
static var baseRarityUpChance = 0.1
enum stats {
	ATK,
	ARMOR,
	EVASION,
	HP,
	MANA,
	CRIT_CHANCE,
	CRIT_DAMAGE,
}
enum ITEM_TYPE {
	SWORD,
	SHIELD,
	AXE,
	FOCUS,
}

#endregion
