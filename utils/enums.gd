class_name Enums
extends Object

#region "materials"
enum material_types {
	GOLD,
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
	material_types.GOLD: preload("res://res/other resources/TradingIcons_112_t.PNG"),
}
#endregion

#region "items"
enum RARITY {
	COMMON,
	UNCOMMON,
	RARE,
	LEGENDARY,
	PERFECT,
}
static var rarity_price_mult = {
	RARITY.COMMON: 1,
	RARITY.UNCOMMON: 1.5,
	RARITY.RARE: 2.25,
	RARITY.LEGENDARY: 3.5,
	RARITY.PERFECT: 6,
}
static var rarity_stat_mult = {
	RARITY.COMMON: 1,
	RARITY.UNCOMMON: 1.1,
	RARITY.RARE: 1.2,
	RARITY.LEGENDARY: 1.35,
	RARITY.PERFECT: 1.5,
}
static var baseRarityUpChance = 0.1
enum STATS {
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
	BOW,
	ARMOR,
	TRINKET,
	CONSUMABLE,
}
static var type_to_sprite = {
	ITEM_TYPE.SWORD: preload("res://res/ui/types/blades.png"),
	ITEM_TYPE.BOW: preload("res://res/ui/types/bow.png"),
}

#endregion
