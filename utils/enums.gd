class_name Enums
extends Object

#region "materials"
enum MATERIALS {
	GOLD,
	IRON,
	WOOD,
}

# shape is used by plugin match3board, used to add resources from matching
const shape_to_material = {
	"wood": MATERIALS.WOOD,
	"iron_ingot": MATERIALS.IRON,
}
const base_shape_to_refined_configuration = {
	"iron_ore": preload("res://gathering/pieces/iron_ingot_configuration.tres"),
}
const material_to_sprite = {
	MATERIALS.IRON: preload("res://res/match/iron_ingot.png"),
	MATERIALS.WOOD: preload("res://res/match/plank.PNG"),
	MATERIALS.GOLD: preload("res://res/other resources/TradingIcons_112_t.PNG"),
}
#endregion

#region "items"
enum RARITY {
	COMMON = 0,
	UNCOMMON = 1,
	RARE = 2,
	LEGENDARY = 3,
	PERFECT = 4,
}
const rarity_price_mult = {
	RARITY.COMMON: 1,
	RARITY.UNCOMMON: 1.5,
	RARITY.RARE: 2.25,
	RARITY.LEGENDARY: 3.5,
	RARITY.PERFECT: 6,
}
const rarity_stat_mult = {
	RARITY.COMMON: 1,
	RARITY.UNCOMMON: 1.1,
	RARITY.RARE: 1.3,
	RARITY.LEGENDARY: 1.6,
	RARITY.PERFECT: 2,
}
const baseRarityUpChance = 0.1
enum STATS {
	ATK,
	ARMOR, # 100/(100+ARMOR) is final damage multiplier
	EVASION, # 100/(100+EVASION) is chance to get hit by ranged
	MAGIC_RESIST, # 100/(100+MR) is chance to get hit by magic
	HP,
	ENERGY,
	ENERGY_REGEN,
	# using warframe rules for crit chance and damage
	# For each 100% percent crit chance, multiply damage by crit damage
	# The remaining crit chance is chance to multiply damage once again
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
const type_to_sprite = {
	ITEM_TYPE.SWORD: preload("res://res/ui/types/blades.png"),
	ITEM_TYPE.BOW: preload("res://res/ui/types/bow.png"),
	ITEM_TYPE.SHIELD: preload("res://res/ui/types/shield.png"),
	ITEM_TYPE.ARMOR: preload("res://res/ui/types/armor.png"),
	ITEM_TYPE.CONSUMABLE: preload("res://res/ui/types/consumable.png"),
	ITEM_TYPE.TRINKET: preload("res://res/ui/types/trinket.png"),
}

enum ATTACK_TYPE {
	MELEE,
	RANGED,
	MAGIC,
}

const reputation_xp_per_level = [10, 30, 60, 100, 150, 210, 270, 340, 420, 510, 600]
const xp_per_hero_level = [0, 10, 20, 40, 80, 160, 320, 640, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000, 5500, 6000, 6500]
const max_level = 20
#endregion

static func get_rarity_color(rarity: int) -> Color:
	match rarity:
		RARITY.UNCOMMON:
			return Color.SEA_GREEN
		RARITY.RARE:
			return Color.DARK_BLUE
		RARITY.LEGENDARY:
			return Color.ORANGE
		RARITY.PERFECT:
			return Color.RED
		_:
			return Color.WHITE
