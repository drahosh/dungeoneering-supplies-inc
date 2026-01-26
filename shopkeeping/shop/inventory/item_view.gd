extends PanelContainer

class_name ItemView
var amount: int
var item: CraftedItem


func initialize(p_item: CraftedItem, p_amount: int):
	amount = p_amount
	item = p_item


func _ready() -> void:
	$MarginContainer/VBoxContainer/Label.text = str(amount)
	$MarginContainer/VBoxContainer/PanelContainer/MarginContainer/TextureRect.texture = item.image
	if item.rarity != Enums.RARITY.COMMON:
		var color = Color.WHITE
		match item.rarity:
			Enums.RARITY.UNCOMMON:
				color = Color.SEA_GREEN
			Enums.RARITY.RARE:
				color = Color.DARK_BLUE
			Enums.RARITY.LEGENDARY:
				color = Color.ORANGE
			Enums.RARITY.PERFECT:
				color = Color.RED
		$MarginContainer/VBoxContainer/PanelContainer.self_modulate = color
		$MarginContainer/VBoxContainer/Label.add_theme_color_override("font_color", color)


func update_amount(p_amount):
	amount = p_amount
	$MarginContainer/VBoxContainer/Label.text = amount
