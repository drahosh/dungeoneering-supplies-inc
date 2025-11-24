extends Node

# Autoloaded as 'Materials'
# describes stackable crafting materials we have, obtained mostly from gathering
signal changed_material_amount(key: int)

var materials: Dictionary = { }


func _ready():
	for material in Enums.material_types.values():
		materials[material] = 0


func add_matched_materials(sequence: Match3Sequence):
	var changed = { }
	for piece in sequence.pieces():
		if piece.shape in Enums.shape_to_material:
			var mat = Enums.shape_to_material[piece.shape]
			materials[mat] += 1
			changed[mat] = 1
	for mat in changed:
		changed_material_amount.emit(mat)


func change_material_amount(mat: int, value: int):
	# value can be positive or negative. Expecting caller to check if can afford
	materials[mat] += value
	changed_material_amount.emit(mat)
