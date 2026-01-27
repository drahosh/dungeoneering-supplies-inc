extends PanelContainer

class_name HeroView
var hero: Hero
var hiring: bool
const my_scene = preload("res://shopkeeping/heroes/hero.tscn")
var equip_hero_signal: Signal


static func get_new(p_hero: Hero, p_equip_hero_signal: Signal = Signal(), p_hiring := false) -> HeroView:
	var hero_view: HeroView = my_scene.instantiate()
	hero_view.hero = p_hero
	hero_view.hiring = p_hiring
	hero_view.equip_hero_signal = p_equip_hero_signal
	return hero_view


func _ready():
	$VBoxContainer/HBoxContainer2/Name.text = hero.full_name()
	$VBoxContainer/HBoxContainer/Image.texture = hero.hero_class.front_image
	hero.xp_changed.connect(setup_xp)
	setup_xp()
	hero.equipment_changed.connect(setup_equipment)
	setup_equipment()
	setup_other()
	setup_stats()
	hero.equipment_changed.connect(setup_stats) # TODO also connect on passive ability change
	# TODO abilities

	$VBoxContainer/HBoxContainer2/AspectRatioContainer/PanelContainer/Expand.toggled.connect(toggle_extra_info)
	if hiring:
		$VBoxContainer/HiringRow.visible = true
		# disable equipment buttons
		$VBoxContainer/HBoxContainer/VBoxContainer/Items/AspectRatioContainer/PanelContainer/Item.disabled = true
		$VBoxContainer/HBoxContainer/VBoxContainer/Items/AspectRatioContainer2/PanelContainer/Item.disabled = true
		$VBoxContainer/HBoxContainer/VBoxContainer/Items/AspectRatioContainer3/PanelContainer/Item.disabled = true
		$VBoxContainer/HBoxContainer/VBoxContainer/Items/AspectRatioContainer4/PanelContainer/Item.disabled = true
		Materials.changed_material_amount.connect(func(key): if key == Enums.MATERIALS.GOLD:toggle_hire_button())
		toggle_hire_button()
		$VBoxContainer/HiringRow/Hire.pressed.connect(hire_hero)
		$VBoxContainer/HiringRow/RichTextLabel.text = "%s " % hero.hero_class.hiring_cost
		$VBoxContainer/HiringRow/RichTextLabel.add_image(Enums.material_to_sprite[Enums.MATERIALS.GOLD], 16, 16)
	else:
		$VBoxContainer/HBoxContainer/VBoxContainer/Items/AspectRatioContainer/PanelContainer/Item.pressed.connect(func(): open_qquip_menu(0))
		$VBoxContainer/HBoxContainer/VBoxContainer/Items/AspectRatioContainer2/PanelContainer/Item.pressed.connect(func(): open_qquip_menu(1))
		$VBoxContainer/HBoxContainer/VBoxContainer/Items/AspectRatioContainer3/PanelContainer/Item.pressed.connect(func(): open_qquip_menu(2))
		$VBoxContainer/HBoxContainer/VBoxContainer/Items/AspectRatioContainer4/PanelContainer/Item.pressed.connect(func(): open_qquip_menu(3))


func setup_xp():
	$VBoxContainer/HBoxContainer2/Level.text = "lv. " + str(hero.level)
	$VBoxContainer/HBoxContainer2/ProgressBar.value = hero.experience
	$VBoxContainer/HBoxContainer2/ProgressBar.max_value = Enums.xp_per_hero_level[hero.level]
	if hero.level == Enums.max_level or hero.experience == Enums.xp_per_hero_level[hero.level]:
		$VBoxContainer/HBoxContainer2/ProgressBar/Label.text = "MAX"
	else:
		$VBoxContainer/HBoxContainer2/ProgressBar/Label.text = "%s/%s" % [
			hero.experience,
			Enums.xp_per_hero_level[hero.level],
		]
	$VBoxContainer/HBoxContainer/Image.texture = hero.hero_class.front_image


func setup_equipment():
	$VBoxContainer/HBoxContainer/VBoxContainer/Items/AspectRatioContainer/PanelContainer/Item.texture_normal = get_hero_item_image(0)
	$VBoxContainer/HBoxContainer/VBoxContainer/Items/AspectRatioContainer2/PanelContainer/Item.texture_normal = get_hero_item_image(1)
	$VBoxContainer/HBoxContainer/VBoxContainer/Items/AspectRatioContainer3/PanelContainer/Item.texture_normal = get_hero_item_image(2)
	$VBoxContainer/HBoxContainer/VBoxContainer/Items/AspectRatioContainer4/PanelContainer/Item.texture_normal = get_hero_item_image(3)
	$VBoxContainer/HBoxContainer/VBoxContainer/Items/AspectRatioContainer/PanelContainer.self_modulate = get_hero_item_outline_color(0)
	$VBoxContainer/HBoxContainer/VBoxContainer/Items/AspectRatioContainer2/PanelContainer.self_modulate = get_hero_item_outline_color(1)
	$VBoxContainer/HBoxContainer/VBoxContainer/Items/AspectRatioContainer3/PanelContainer.self_modulate = get_hero_item_outline_color(2)
	$VBoxContainer/HBoxContainer/VBoxContainer/Items/AspectRatioContainer4/PanelContainer.self_modulate = get_hero_item_outline_color(3)


func get_hero_item_image(slot: int) -> CompressedTexture2D:
	var item: CraftedItem = hero.items[slot]
	if item:
		return item.image
	else:
		return Enums.type_to_sprite[hero.hero_class.item_slots[slot]]


func get_hero_item_outline_color(slot: int) -> Color:
	var item: CraftedItem = hero.items[slot]
	if item:
		return Enums.get_rarity_color(item.rarity)
	else:
		return Color.GRAY


func toggle_hire_button():
	if (
		Materials.can_afford({ Enums.MATERIALS.GOLD: hero.hero_class.hiring_cost })
		and Guilds.hired_heroes.size() < BuildingProgress.get_max_hero_amount()
	):
		$VBoxContainer/HiringRow/Hire.disabled = false
	else:
		$VBoxContainer/HiringRow/Hire.disabled = true


func toggle_extra_info(toggle: bool):
	$"VBoxContainer/Extra Info".visible = toggle


func setup_stats():
	$"VBoxContainer/Extra Info/VBoxContainer2/Stats".text = Utils.stats_to_string(hero.stats, true)


func setup_other():
	var textbox = $"VBoxContainer/Extra Info/VBoxContainer/Other"
	textbox.text = "top-down image: "
	textbox.add_image(hero.hero_class.top_down_image, 32, 32)
	textbox.append_text("\nClass: %s\n" % hero.hero_class.name)
	textbox.append_text("Guild: %s " % hero.hero_class.guild.name)
	textbox.add_image(hero.hero_class.guild.image, 32, 32)


func open_qquip_menu(slot: int):
	equip_hero_signal.emit(hero, slot)


func hire_hero():
	Guilds.hire_hero(hero)
