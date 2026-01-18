extends PanelContainer

class_name ItemView
var amount: int
var item: CraftedItem


func initialize(p_item: CraftedItem, p_amount: int):
	amount = p_amount
	item = p_item


func _ready() -> void:
	$MarginContainer/VBoxContainer/Label.text = amount
	$MarginContainer/VBoxContainer/PanelContainer/MarginContainer/TextureRect.texture = item.image
	if item.rarity != Enums.rarity.COMMON:
		var color
		match item.rarity:
			Enums.rarity.UNCOMMON:
				color = Color.SEA_GREEN
			Enums.rarity.RARE:
				color = Color.DARK_BLUE
			Enums.rarity.LEGENDARY:
				color = Color.ORANGE
			Enums.rarity.PERFECT:
				color = Color.RED
		$MarginContainer/VBoxContainer/PanelContainer.self_modulate(color)
		$MarginContainer/VBoxContainer/Label.add_theme_font_override("font_color", color)


func update_amount(p_amount):
	amount = p_amount
	$MarginContainer/VBoxContainer/Label.text = amount
