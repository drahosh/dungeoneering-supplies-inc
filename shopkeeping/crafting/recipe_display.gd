extends PanelContainer

class_name RecipeView
var recipe: ItemRecipe # needs to be set by parent before attaching to tree
var material_tile = preload("res://utils/material_tile.tscn")


func _ready() -> void:
	$VBoxContainer/TextureRect.texture = recipe.image
	$VBoxContainer/HBoxContainer/Label.text = str(recipe.value)
	$VBoxContainer/Name.text = recipe.item_name
	#TODO amount
	for mat in recipe.cost:
		var tile = material_tile.instantiate()
		tile.find_child("TextureRect").texture = Enums.material_to_sprite[mat]
		tile.find_child("Label").text = str(recipe.cost[mat])
	toggle_craftable_effect()
	Materials.changed_material_amount.connect(toggle_craftable_effect)


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


func change_item_amount():
	#TODO
	pass
