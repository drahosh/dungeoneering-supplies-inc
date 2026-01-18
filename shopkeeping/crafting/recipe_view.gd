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
		$VBoxContainer/HFlowContainer.add_child(tile)
	toggle_craftable_effect()
	Materials.changed_material_amount.connect(func(_u): toggle_craftable_effect())
	Inventory.inventory_changed.connect(set_item_amounts)
	$VBoxContainer/Button.pressed.connect(recipe.craft_to_inventory)
	set_item_amounts()


func toggle_craftable_effect():
	if recipe.craftable():
		modulate.a = 1
		modulate.g = 1
		modulate.b = 1

		$VBoxContainer/Button.disabled = false
	else:
		modulate.a = 0.2
		modulate.g = 0.5
		modulate.b = 0.5

		$VBoxContainer/Button.disabled = true


func set_item_amounts():
	var amounts = Inventory.get_item_amount_per_rarity(recipe)
	$VBoxContainer/Amount.text = "%s [color=green]%s[/color] [color=blue]%s[/color] [color=yellow]%s[/color] [color=red]%s[/color]" % [
		amounts[Enums.RARITY.COMMON],
		amounts[Enums.RARITY.UNCOMMON],
		amounts[Enums.RARITY.RARE],
		amounts[Enums.RARITY.LEGENDARY],
		amounts[Enums.RARITY.PERFECT],
	]
