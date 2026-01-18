extends VBoxContainer

class_name GatheringOption
#TODO decide on cost of gathering
var label: String
var target_scene_file_name: String
static var self_scene := preload("res://shopkeeping/gather_select/Gather_select_option.tscn")


static func get_new(p_label: String, scene_file_name: String) -> GatheringOption:
	var to_return: GatheringOption = self_scene.instantiate()
	to_return.label = p_label
	to_return.target_scene_file_name = scene_file_name
	return to_return


func _ready() -> void:
	$PanelContainer/HBoxContainer/RichTextLabel.text = label
	$PanelContainer/HBoxContainer/Button.pressed.connect(change_scene)


func change_scene():
	var x = get_tree().change_scene_to_file(target_scene_file_name)
	print(x)
