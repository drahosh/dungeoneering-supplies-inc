extends Object
class_name Enums

enum material_types  {
	IRON,
	WOOD,
}

# shape is used by plugin match3board, used to add resources from matching
static var shape_to_material = {
	"wood": material_types.WOOD,
	"iron_ingot": material_types.IRON,
}

static var base_shape_to_refined_configuration = {
	"iron_ore" : load("res://gathering/pieces/iron_ingot_configuration.tres"),
}	
