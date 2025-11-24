extends VBoxContainer

var material_scene = preload("res://gathering/material_tile.tscn")
var material_to_tile = { }


func _ready() -> void:
	for mat in BuildingProgress.get_unlocked_materials():
		var material_tile = material_scene.instantiate()
		material_tile.find_child("TextureRect").texture = Enums.material_to_sprite[mat]
		material_to_tile[mat] = material_tile
		self.add_child(material_tile)
	Materials.changed_material_amount.connect(update_mat)


func update_mat(mat: int):
	material_to_tile[mat].find_child("Label").text = str(Materials.materials[mat])
