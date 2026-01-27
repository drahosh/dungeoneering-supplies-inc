extends PanelContainer

class_name RecipeView
var recipe: ItemRecipe # needs to be set by parent before attaching to tree
var material_tile = preload("res://utils/material_tile.tscn")


func _ready() -> void:
	$VBoxContainer/TextureRect.texture = recipe.image
	$VBoxContainer/HBoxContainer/Label.text = str(recipe.value)
	$VBoxContainer/Name.text = recipe.item_name
	for mat in recipe.cost:
		var tile = material_tile.instantiate()
		tile.find_child("TextureRect").texture = Enums.material_to_sprite[mat]
		tile.find_child("Label").text = str(recipe.cost[mat])
		$VBoxContainer/Cost.add_child(tile)
	toggle_craftable_effect()
	Materials.changed_material_amount.connect(func(_u): toggle_craftable_effect())
	Inventory.inventory_changed.connect(set_item_amounts)
	$VBoxContainer/HBoxContainer2/Craft.pressed.connect(recipe.craft_to_inventory)
	set_item_amounts()
	$VBoxContainer/Extra/MenuButton.item_selected.connect(setup_stats)
	setup_stats()
	$VBoxContainer/HBoxContainer2/Expand.toggled.connect(toggle_extra)


func toggle_craftable_effect():
	if recipe.craftable():
		modulate.a = 1
		modulate.g = 1
		modulate.b = 1

		$VBoxContainer/HBoxContainer2/Craft.disabled = false
	else:
		modulate.a = 0.2
		modulate.g = 0.5
		modulate.b = 0.5

		$VBoxContainer/HBoxContainer2/Craft.disabled = true


func set_item_amounts():
	var amounts = Inventory.get_item_amount_per_rarity(recipe.item_name)
	$VBoxContainer/Amount.text = "%s [color=green]%s[/color] [color=blue]%s[/color] [color=yellow]%s[/color] [color=red]%s[/color]" % [
		amounts[Enums.RARITY.COMMON],
		amounts[Enums.RARITY.UNCOMMON],
		amounts[Enums.RARITY.RARE],
		amounts[Enums.RARITY.LEGENDARY],
		amounts[Enums.RARITY.PERFECT],
	]


func setup_stats(rarity := Enums.RARITY.COMMON):
	$VBoxContainer/Extra/RichTextLabel.text = Utils.stats_to_string(recipe.get_stats_for_rarity(rarity))


func toggle_extra(toggled: bool):
	$VBoxContainer/Extra.visible = toggled
