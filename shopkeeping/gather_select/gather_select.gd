extends VBoxContainer

func _ready() -> void:
	var default = GatheringOption.get_new("Basic gathering\nGain iron and wood", "res://gathering/Gathering.tscn")
	self.add_child(default)
