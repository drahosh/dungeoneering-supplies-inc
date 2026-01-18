extends VBoxContainer

var recipe_scene = preload("res://shopkeeping/crafting/recipe.tscn")
var current_button: TextureButton
var selected_button_material = preload("res://shopkeeping/crafting/button_selected_material.tres")
var current_type_filter: int = -1


func _ready() -> void:
	setup_recipes()
	current_button = $PanelContainer2/VBoxContainer/ScrollContainer2/HBoxContainer/All
	setup_button(current_button, -1)
	current_button.material = selected_button_material
	for type in CraftingRecipes.unlocked_types:
		var button = TextureButton.new()
		button.texture_normal = Enums.type_to_sprite[type]
		setup_button(button, type)
		$PanelContainer2/VBoxContainer/ScrollContainer2/HBoxContainer.add_child(button)


func setup_button(button: TextureButton, type: int):
	button.toggle_mode = true
	button.button_pressed = false
	button.button_group = $PanelContainer2/VBoxContainer/ScrollContainer2/HBoxContainer/All.button_group
	button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	button.pressed.connect(func(): change_filter(button, type))


func change_filter(button: TextureButton, type: int):
	current_button.material = null
	button.material = selected_button_material
	current_type_filter = type
	current_button = button
	setup_recipes()


func setup_recipes():
	for child in $PanelContainer2/VBoxContainer/ScrollContainer/RecipesShown.get_children():
		child.free()
	for recipe in CraftingRecipes.get_unlocked_recipes():
		if current_type_filter == -1 or current_type_filter == recipe.type:
			var instance = recipe_scene.instantiate()
			instance.recipe = recipe
			$PanelContainer2/VBoxContainer/ScrollContainer/RecipesShown.add_child(instance)
