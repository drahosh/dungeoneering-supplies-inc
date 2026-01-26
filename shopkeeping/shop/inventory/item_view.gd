extends PanelContainer

class_name ItemView
var amount: int
var item: CraftedItem


func initialize(p_item: CraftedItem, p_amount: int):
	amount = p_amount
	item = p_item


func _ready() -> void:
	$VBoxContainer/Label.text = str(amount)
	$VBoxContainer/PanelContainer/TextureRect.texture = item.image
	if item.rarity != Enums.RARITY.COMMON:
		var color = Enums.get_rarity_color(item.rarity)
		$VBoxContainer/PanelContainer.self_modulate = color
		$VBoxContainer/Label.add_theme_color_override("font_color", color)


func update_amount(p_amount):
	amount = p_amount
	$VBoxContainer/Label.text = amount
