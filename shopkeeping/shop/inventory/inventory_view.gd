extends PanelContainer

class_name InventoryView
var item_scene = preload("res://shopkeeping/shop/inventory/item.tscn")


func _ready() -> void:
	show_inventory()
	Inventory.inventory_changed.connect(show_inventory)
	$VBoxContainer/HBoxContainer/MenuButton.item_selected.connect(func(_u): show_inventory())


func show_inventory() -> void:
	for child in $VBoxContainer/ScrollContainer/GridContainer.get_children():
		child.free()
	var itemList: Array = Inventory.get_as_list() # array of arrays [item, amount]
	var sorting_function
	match $VBoxContainer/HBoxContainer/MenuButton.selected:
		0:
			sorting_function = func(a, b):
				return (a[0].tier > b[0].tier
					or a[0].tier == b[0].tier and a[0].item_name < b[0].item_name
					or a[0].tier == b[0].tier and a[0].item_name < b[0].item_name and a[0].rarity < b[0].rarity )
		1:
			sorting_function = func(a, b): return a[0].value > b[0].value
		2:
			sorting_function = func(a, b):
				return a[1] > b[1]
		3:
			sorting_function = func(a, b):
				return a[0].rarity > b[0].rarity or (
					a[0].rarity == b[0].rarity and (
						a[0].tier > b[0].tier
						or a[0].tier == b[0].tier and a[0].item_name < b[0].item_name ) )
	itemList.sort_custom(sorting_function)
	for pair in itemList:
		var child: ItemView = item_scene.instantiate()
		child.initialize(pair[0], pair[1])
		$VBoxContainer/ScrollContainer/GridContainer.add_child(child)
