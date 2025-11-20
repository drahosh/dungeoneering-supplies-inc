extends VBoxContainer

@onready
var board = $HBoxContainer/Matching/Node2D/Match3Board

func _ready():
	board.consumed_sequence.connect(Materials.add_matched_materials)
