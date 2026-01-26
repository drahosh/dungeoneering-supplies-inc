extends RefCounted

class_name Hero

var hero_class: HeroClass
var first_name: String
var last_name: String
var items := [null, null, null, null]
var level := 0
var experience := 0:
	set(value):
		if value > Enums.xp_per_hero_level[level]:
			if level >= hero_class.guild.get_max_level_from_tier():
				# if at max level, xp still accumulates until next level up
				value = Enums.xp_per_hero_level[level]
			else:
				value -= Enums.xp_per_hero_level[level]
				level_up()
		experience = value
		xp_changed.emit()
var stats := { }
var learned_active_skills := []
var learned_passive_skills := []
var active_skill_slots := [locked, locked]
var passsive_skill_slots := [locked, locked, locked, locked]
const locked = "LOCKED"
const empty = "EMPTY"

signal xp_changed
signal equipment_changed


func _init(p_hero_class: HeroClass, p_level: int) -> void:
	hero_class = p_hero_class
	var names_generated = NameGenerator.new().new_name()
	first_name = names_generated[2]
	last_name = names_generated[5]
	while p_level > level:
		# even heroes recruited at level 1 get some starting skill from levelup
		level_up()


func level_up() -> void:
	level += 1
	# TODO learn skills, unlock skill slots
	recalculate_stats()


func recalculate_stats() -> void:
	# Sums up stats from class+level, items, and skills. Saves them to 'stats'
	stats = hero_class.base_stats
	# init unmentioned stats to 0
	for stat in Enums.STATS.values():
		if stat not in stats:
			stats[stat] = 0
	# add stat bonuses for level
	for stat in hero_class.level_stats:
		stats[stat] += (level - 1) * hero_class.level_stats[stat]
	# add stats from equipmnent
	for item: CraftedItem in items:
		if item:
			for stat in item.stats:
				stats[stat] += item.stats[stat]
	# TODO add stats from passive skills


func _get_max_tier() -> int:
	@warning_ignore("integer_division")
	return ((level - 1) / 5) + 1


func equip_item(item: CraftedItem, slot: int, from_inventory := true):
	if item.tier > _get_max_tier() or item.type != hero_class.item_slots[slot]:
		print_debug("Trying to equip unequippable item")
		return
	if items[slot]:
		Inventory.add_item(items[slot])
	items[slot] = item
	if from_inventory:
		Inventory.remove_item(item)
	recalculate_stats()
	equipment_changed.emit()


func get_equippable_items_in_inventory(slot: int) -> Array:
	return Inventory.get_items_of_types_under_tier([hero_class.item_slots[slot]], _get_max_tier())


func autoequip():
	# Automatically look for best equipment
	for slot in range(4):
		for item in get_equippable_items_in_inventory(slot):
			if item.is_strictly_better(items[slot]):
				equip_item(item, slot)


func full_name():
	return first_name + " " + last_name
