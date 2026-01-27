extends PanelContainer

class_name ItemView
var amount: int
var item: CraftedItem

var item_selected_signal: Signal


func initialize(p_item: CraftedItem, p_amount: int, return_signal: Signal = Signal()):
	amount = p_amount
	item = p_item
	item_selected_signal = return_signal


func _ready() -> void:
	$VBoxContainer/Control/Label.text = str(amount)
	$VBoxContainer/PanelContainer/TextureButton.texture_normal = item.image
	$VBoxContainer/Control/Expand.toggled.connect(toggle_expanded_view)
	$VBoxContainer/PanelContainer.self_modulate = Enums.get_rarity_color(item.rarity)

	if not item_selected_signal.is_null():
		$VBoxContainer/PanelContainer/TextureButton.pressed.connect(func(): item_selected_signal.emit(item))
	$VBoxContainer/Detailed/Value.text = "%s " % item.value
	$VBoxContainer/Detailed/Value.add_image(Enums.material_to_sprite[Enums.MATERIALS.GOLD], 16, 16)
	$VBoxContainer/Detailed/Stats.text = Utils.stats_to_string(item.stats)


func update_amount(p_amount):
	amount = p_amount
	$VBoxContainer/Label.text = amount


func toggle_expanded_view(toggled: bool):
	$VBoxContainer/Detailed.visible = toggled
