extends PanelContainer

signal open_equip_menu(hero: Hero, slot: int)
signal equip_item_selected(item: CraftedItem)

var selected_hero: Hero = null
var selected_slot: int = -1
const inventory_scene = preload("res://shopkeeping/shop/inventory/inventory.tscn")
var open_inentory: InventoryView


func _ready() -> void:
	$Current/HBoxContainer/Hiring.pressed.connect(func(): toggle_hiring(true))
	$Hireable/Back.pressed.connect(func(): toggle_hiring(false))
	$Current/HBoxContainer/Autoequip.pressed.connect(autoequip_all)
	open_equip_menu.connect(equip_open)
	equip_item_selected.connect(equip_item)
	Guilds.changed_hireable_heroes.connect(setup_hireable)
	Guilds.changed_hired_heroes.connect(setup_hired)
	setup_hireable()
	setup_hired()
	$EquipMenu/HBoxContainer/Back.pressed.connect(equip_close)


func toggle_hiring(hiring: bool):
	$Current.visible = not hiring
	$Hireable.visible = hiring


func autoequip_all():
	for child in $Current/ScrollContainer/Heroes.get_children():
		child.hero.autoequip()


func setup_hired():
	for child in $Current/ScrollContainer/Heroes.get_children():
		child.queue_free()

	for hero: Hero in Guilds.hired_heroes:
		$Current/ScrollContainer/Heroes.add_child(HeroView.get_new(hero, open_equip_menu))


func setup_hireable():
	for child in $Hireable/ScrollContainer/Heroes.get_children():
		child.queue_free()
	for hero in Guilds.hireable_heroes:
		$Hireable/ScrollContainer/Heroes.add_child(HeroView.get_new(hero, open_equip_menu, true))


func equip_open(hero: Hero, slot: int):
	hero.equip_item(null, slot)
	selected_hero = hero
	selected_slot = slot

	open_inentory = inventory_scene.instantiate()

	open_inentory.get_inventory_function = (
		func():
			return Inventory.get_items_of_types_under_tier([hero.hero_class.item_slots[slot]], hero._get_max_tier(), true)
	)
	open_inentory.item_selected_signal = equip_item_selected
	# Can be activated only if we're not hiring, but we set hiring to invisible too just to make sure
	$Current.visible = false
	$Hireable.visible = false
	$EquipMenu.visible = true

	$EquipMenu.add_child(open_inentory)


func equip_close():
	open_inentory.queue_free()
	$EquipMenu.visible = false
	$Current.visible = true
	selected_hero = null
	selected_slot = -1


func equip_item(item: CraftedItem):
	selected_hero.equip_item(item, selected_slot)
	equip_close()
