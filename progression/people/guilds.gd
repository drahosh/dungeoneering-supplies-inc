extends Node

# Autoloaded as Guilds

var unlocked_guilds = { }
var guilds = { }
var classes = { }
const placeholder_image := preload("res://icon.svg")
var customers_per_day := 4
var streak_customers := 0 #TODO, unlock with upgrade
var refused_customers_today := 0
var active_customers = []
var hired_heroes = []
var hireable_heroes = []

signal changed_hired_heroes
signal changed_hireable_heroes


func _ready() -> void:
	create_classes()
	create_guilds()
	unlock_guild("Mercenaries")


func generate_customers() -> void:
	active_customers = [] # TODO preserve quest customers when they get added
	while active_customers.size() < customers_per_day + streak_customers:
		var customer = unlocked_guilds.values().pick_random().generate_customer()
		if customer:
			active_customers.append(customer)
		else:
			# fallback for unlikely case we have a customer unlocked but know none of their recipes
			active_customers.append(unlocked_guilds["Mercenaries"].generate_customer())


func end_day():
	# Dissapointed customers lose reputation
	for customer: Customer in active_customers:
		customer.hero_class.guild.reputation -= 1


func unlock_guild(guild_name: String):
	unlocked_guilds[guild_name] = guilds[guild_name]


func create_guilds() -> void:
	guilds["Mercenaries"] = Guild.new(
		"Mercenaries",
		placeholder_image,
		classes["Fighter"],
		classes["Medic"],
		[
			{ Guild.UPGRADE_TYPE.UNLOCK_HERO: 1 },
			{ Guild.UPGRADE_TYPE.WINDOWSHOP_RATE: 0.2, Guild.UPGRADE_TYPE.MAX_TIER: 2 },
			{ Guild.UPGRADE_TYPE.UNLOCK_CUSTOMER: 2, Guild.UPGRADE_TYPE.SELLOFF_RATE: 0.07 },
			{ Guild.UPGRADE_TYPE.UNLOCK_HERO: 2, Guild.UPGRADE_TYPE.MAX_TIER: 3 },
		],
		0.1,
		0.05,
		placeholder_image,
	)


func create_classes() -> void:
	classes["Fighter"] = HeroClass.new(
		"Fighter",
		[Enums.ITEM_TYPE.SWORD, Enums.ITEM_TYPE.SHIELD, Enums.ITEM_TYPE.ARMOR, Enums.ITEM_TYPE.CONSUMABLE],
		[],
		[],
		Enums.ATTACK_TYPE.MELEE,
		{
			Enums.STATS.ATK: 5,
			Enums.STATS.HP: 50,
			Enums.STATS.CRIT_CHANCE: 0.01,
			Enums.STATS.CRIT_DAMAGE: 2,
		},
		{
			Enums.STATS.ATK: 1,
			Enums.STATS.HP: 10,
			Enums.STATS.CRIT_CHANCE: 0.005,
			Enums.STATS.EVASION: 0.5,
		},
		placeholder_image,
		placeholder_image,
		100,
	)

	classes["Medic"] = HeroClass.new(
		"Medic",
		[Enums.ITEM_TYPE.SWORD, Enums.ITEM_TYPE.ARMOR, Enums.ITEM_TYPE.CONSUMABLE, Enums.ITEM_TYPE.TRINKET],
		[],
		[],
		Enums.ATTACK_TYPE.MELEE,
		{
			Enums.STATS.ATK: 5,
			Enums.STATS.HP: 50,
			Enums.STATS.EVASION: 2,
		},
		{
			Enums.STATS.ATK: 1,
			Enums.STATS.HP: 5,
			Enums.STATS.EVASION: 1,
		},
		placeholder_image,
		placeholder_image,
		500,
	)


func hire_hero(hero: Hero):
	Materials.pay_materials({ Enums.MATERIALS.GOLD: hero.hero_class.hiring_cost })
	hired_heroes.append(hero)
	hireable_heroes.remove_at(hireable_heroes.find(hero))
	changed_hired_heroes.emit()
	changed_hireable_heroes.emit()


func fire_hero(hero: Hero):
	hired_heroes.remove_at(hired_heroes.find(hero))
	changed_hired_heroes.emit()


func generate_hireable_heroes():
	hireable_heroes = []
	for guild_name in guilds:
		for hero_class: HeroClass in guilds[guild_name].heroes:
			hireable_heroes.append(hero_class.generate_hero())
