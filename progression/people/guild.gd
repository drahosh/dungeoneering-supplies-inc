extends RefCounted

class_name Guild

# Guild is a group of adventurers
# Each guild is composed of two hero classes. First is always unlocked at the start as customer
# Later, first class is unlocked as hero, then second as customer, and finaly as hero
# Guilds gain reputation when you sell or buy items from them
# Guilds lose reputation when you refuse to sell to them or end day without seling to them

var name: String
signal reputation_changed
var current_reputation_xp: int:
	set(value):
		if value < 0:
			value = 0
		if value > Enums.reputation_xp_per_level[current_reputation_level]:
			value -= Enums.reputation_xp_per_level[current_reputation_level]
			current_reputation_level += 1
		current_reputation_xp = value
		reputation_changed.emit()
var current_reputation_level: int
var class1: HeroClass
var class2: HeroClass
var customers = []
var heroes = []
var upgrades_per_rep_level: Array # one member per reputation level,
# each upgrades_per_rep_level member is multiple upgrades in format dict{UPGRADE_TYPE -> parameter)
var windowshopping_rate: float # chance for customers to buy from inventory
var selloff_rate: float # chance for customers to sell discounted bulk items to player instead
var icon: CompressedTexture2D
var max_tier: int # max item tier users can buy. New and max hero level also depends on this
enum UPGRADE_TYPE {
	UNLOCK_CUSTOMER,
	UNLOCK_HERO,
	WINDOWSHOP_RATE,
	SELLOFF_RATE,
	MAX_TIER,
	UNLOCK_BUILDING,
}


# Setup detault values at start of game, is supposed to be overridden
func _init(
		p_name: String,
		p_class1: HeroClass,
		p_class2: HeroClass,
		p_upgrades_per_rep_level: Array,
		p_windowshopping_rate: float,
		p_seloff_rate: float,
		p_icon: CompressedTexture2D,
		p_current_reputation_xp := 0,
		p_current_reputation_level := 0,
		p_max_tier := 1,
):
	name = p_name
	class1 = p_class1
	class2 = p_class2
	class1.guild = self
	class2.guild = self
	upgrades_per_rep_level = p_upgrades_per_rep_level
	windowshopping_rate = p_windowshopping_rate
	selloff_rate = p_seloff_rate
	icon = p_icon
	current_reputation_xp = p_current_reputation_xp
	current_reputation_level = p_current_reputation_level
	customers = [class1]
	max_tier = p_max_tier
	if current_reputation_level > 0:
		for i in range(current_reputation_level):
			apply_upgrades(upgrades_per_rep_level[i])


func apply_upgrades(upgrades: Dictionary):
	for upgrade_type in upgrades:
		var parameter = upgrades[upgrade_type]
		match upgrade_type:
			UPGRADE_TYPE.UNLOCK_CUSTOMER:
				customers.append(parameter)
			UPGRADE_TYPE.UNLOCK_HERO:
				heroes.append(parameter)
			UPGRADE_TYPE.WINDOWSHOP_RATE:
				windowshopping_rate = parameter
			UPGRADE_TYPE.SELLOFF_RATE:
				selloff_rate = parameter
			UPGRADE_TYPE.MAX_TIER:
				max_tier = parameter
			UPGRADE_TYPE.UNLOCK_BUILDING:
				#TODO
				pass


func get_upgrades_description(upgrades: Dictionary) -> String:
	var strings = []
	for upgrade_type in upgrades:
		var parameter = upgrades[upgrade_type]
		match upgrade_type:
			UPGRADE_TYPE.UNLOCK_CUSTOMER:
				strings.append("Unlock a new class as customers: %s" % (class1.name if parameter == 1 else class2.name))
			UPGRADE_TYPE.UNLOCK_HERO:
				strings.append("Unlock a new class for hire: %s" % (class1.name if parameter == 1 else class2.name))
			UPGRADE_TYPE.WINDOWSHOP_RATE:
				strings.append("Heroes from this class now have %s%%chance to windowshop" % (parameter * 100))
			UPGRADE_TYPE.SELLOFF_RATE:
				strings.append("Heroes from this class now have %s%% chance to sell you items instead" % (parameter * 100))
			UPGRADE_TYPE.MAX_TIER:
				strings.append("Heroes from this class now buy items up to tier %s and can reach level %s" % [parameter, get_max_level_from_tier(parameter)])
			UPGRADE_TYPE.UNLOCK_BUILDING:
				#TODO
				pass
	return "\n".join(strings)


func get_max_level_from_tier(tier: int = max_tier):
	return tier * 5


func generate_customer() -> Customer:
	return customers.pick_random().generate_customer()
