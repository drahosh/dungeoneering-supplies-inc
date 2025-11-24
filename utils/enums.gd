class_name Enums
extends Object

enum material_types {
	IRON,
	WOOD,
}

# shape is used by plugin match3board, used to add resources from matching
static var shape_to_material = {
	"wood": material_types.WOOD,
	"iron_ingot": material_types.IRON,
}
static var base_shape_to_refined_configuration = {
	"iron_ore": load("res://gathering/pieces/iron_ingot_configuration.tres"),
}
static var material_to_sprite = {
	material_types.IRON: preload("res://res/match/iron_ingot.png"),
	material_types.WOOD: preload("res://res/match/wood.PNG"),
}
