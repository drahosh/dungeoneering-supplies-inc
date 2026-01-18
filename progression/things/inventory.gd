extends Node

# autoloaded as 'Inventory'
# Holds data on craftable items held in inventory (not on heroes)

var inventory: Dictionary = { } # nested dictionary, itemName -> {rarity -> [item, amount]}

signal inventory_changed


func add_item(item: CraftedItem, amount := 1):
	if item.item_name not in inventory:
		inventory[item.item_name] = { }
	if item.rarity not in inventory[item.item_name]:
		inventory[item.item_name][item.rarity] = [item, 0]
	inventory[item.item_name][item.rarity][1] += amount
	inventory_changed.emit()


func remove_item(item: CraftedItem, amount := 1):
	inventory[item.item_name][item.rarity][1] -= amount
	if inventory[item.item_name][item.rarity][1] == 0:
		inventory[item.item_name].erase(item.rarity)
	if inventory[item.item_name].size() == 0:
		inventory.erase(item.item_name)
	inventory_changed.emit()


func get_amount(item: CraftedItem) -> int:
	# using get with defaults to avoid errors when asked for amount of item player doesn't have
	return inventory.get(item.item_name, { }).get(item.rarity, [null, 0])[1]


func get_as_list() -> Array:
	# returns array [[item, amount],[item, amount]...]
	var to_return = []
	for item_name in inventory:
		for rarity in inventory[item_name]:
			to_return.append(inventory[item_name][rarity])
	return to_return
