extends RefCounted

class_name HeroClass

var guild: Guild # set by guild init

var name: String
var item_slots: Array # every hero has 4 item slots. Here each takes one Enums.ITEM_TYPE

var passive_skills: Array # List of possible passive skils, TODO
var active_skills: Array # List of possible active skills, TODO

var basic_attack_type: Enums.ATTACK_TYPE

var base_stats: Dictionary # Level 1 stats hero starts with, from Enums.STATS
var level_stats: Dictionary # stats hero gains by default per level up
# for both base_stats and level_stats not all stats need be represented, those not mentioned are by default 0

var front_image: CompressedTexture2D
var top_down_image: CompressedTexture2D


func _init(
		p_name: String,
		p_item_slots: Array,
		p_passive_skills: Array,
		p_active_skills: Array,
		p_basic_attack_type: Enums.ATTACK_TYPE,
		p_base_stats: Dictionary,
		p_level_stats: Dictionary,
		p_front_image: CompressedTexture2D,
		p_top_down_image: CompressedTexture2D,
) -> void:
	name = p_name
	item_slots = p_item_slots
	passive_skills = p_passive_skills
	active_skills = p_active_skills
	basic_attack_type = p_basic_attack_type
	base_stats = p_base_stats
	level_stats = p_level_stats
	front_image = p_front_image
	top_down_image = p_top_down_image


func generate_customer() -> Customer:
	# TODO selloff system
	if randf() < guild.windowshopping_rate:
		var items: Array = Inventory.get_items_of_types_under_tier(item_slots, guild.max_tier)
		if not items.is_empty():
			return Customer.new(Customer.CUSTOMER_TYPE.BUYING, items.pick_random(), self)
	var eligible_unlocked_recipes: Array = CraftingRecipes.get_unlocked_recipes_of_types_under_tier(item_slots, guild.max_tier)
	if not eligible_unlocked_recipes.is_empty():
		return Customer.new(Customer.CUSTOMER_TYPE.BUYING, eligible_unlocked_recipes.pick_random().item_from_recipe(), self)
	else:
		return null # we can't craft an item this customer would want


func generate_hero():
	pass # TODO
