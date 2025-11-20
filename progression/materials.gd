extends Node

# Autoloaded as 'Materials'
# describes stackable crafting materials we have, obtained from gathering and from dungeons

var materials = {}

func _ready():
	for material in Enums.material_types.values():
		materials[material] = 0

func add_matched_materials(sequence: Match3Sequence):
	for piece in sequence.pieces():
		if piece.shape in Enums.shape_to_material:
			materials[Enums.shape_to_material[piece.shape]]+=1
