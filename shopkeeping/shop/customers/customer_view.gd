extends PanelContainer

class_name CustomerView
const my_scene = preload("res://shopkeeping/shop/customers/customer.tscn")
var customer: Customer


static func get_new(p_customer: Customer):
	var scene = my_scene.instantiate()
	scene.customer = p_customer
	return scene


func _ready() -> void:
	$VBoxContainer/HBoxContainer/CustomerImage.texture = customer.hero_class.front_image
	$VBoxContainer/HBoxContainer/AspectRatioContainer/Outline/ItemImage.texture = customer.item.image
	# TODO seloff - account for multiple items/resources
	var rarity_text: String
	match customer.item.rarity:
		Enums.RARITY.COMMON:
			rarity_text = "a"
		Enums.RARITY.UNCOMMON:
			rarity_text = "an uncommon"
		Enums.RARITY.RARE:
			rarity_text = "a rare"
		Enums.RARITY.LEGENDARY:
			rarity_text = "a legendary"
		Enums.RARITY.PERFECT:
			rarity_text = "a perfect"

	$VBoxContainer/HBoxContainer/RichTextLabel.text = "[b]%s[/b] wants to %s %s [b]%s[/b] for %s" % [
		customer.hero_class.name,
		"buy" if customer.type == customer.CUSTOMER_TYPE.SELLING else "[b]sell[/b]",
		rarity_text,
		customer.item.item_name,
		customer.item.value,
	]
	$VBoxContainer/HBoxContainer/AspectRatioContainer/Outline.modulate = Enums.get_rarity_color(customer.item.rarity)
	$VBoxContainer/HBoxContainer/RichTextLabel.add_image(Enums.material_to_sprite[Enums.MATERIALS.GOLD], 16, 16)
	customer.hero_class.guild.reputation_changed.connect(set_reputation)
	set_reputation()
	Inventory.inventory_changed.connect(toggle_sellable)
	toggle_sellable()
	$VBoxContainer/HBoxContainer3/Sell.pressed.connect(sell)
	$VBoxContainer/HBoxContainer3/Refuse.pressed.connect(refuse)


func can_sell() -> bool:
	# TODO similar function for seloff customers
	var rarity_to_amount = Inventory.get_item_amount_per_rarity(customer.item.item_name)
	for rarity in rarity_to_amount:
		if rarity >= customer.item.rarity and rarity_to_amount[rarity] > 0:
			return true
	return false


func toggle_sellable():
	if can_sell():
		$VBoxContainer/HBoxContainer3/Sell.disabled = false
		#$VBoxContainer/HBoxContainer3/Sell.modulate = Color.GREEN
	else:
		$VBoxContainer/HBoxContainer3/Sell.disabled = true
		#$VBoxContainer/HBoxContainer3/Sell.modulate = Color.DIM_GRAY


func sell():
	var amounts = Inventory.get_item_amount_per_rarity(customer.item.item_name)
	if amounts[customer.item.rarity] > 0:
		Inventory.remove_item(customer.item)
		Materials.change_material_amount(Enums.MATERIALS.GOLD, customer.item.value)
		customer.hero_class.guild.current_reputation_xp += pow(2, customer.item.rarity)
		queue_free()

	else:
		for rarity in range(customer.item.rarity + 1, Enums.RARITY.PERFECT + 1):
			if amounts[rarity] > 0:
				# Selling a better item than necessary
				# This gets us more reputation, but not more gold
				# TODO popup warning with confirmation
				Materials.change_material_amount(Enums.MATERIALS.GOLD, customer.item.value)
				customer.item.rarity = rarity
				Inventory.remove_item(customer.item)
				customer.hero_class.guild.current_reputation_xp += 2 ^ rarity
				queue_free()
				return


func refuse():
	Guilds.active_customers.remove_at(Guilds.active_customers.find(self))
	customer.hero_class.guild.current_reputation_xp -= 1
	queue_free()


func set_reputation():
	$VBoxContainer/HBoxContainer2/RepLevel.text = "Rep: %s" % customer.hero_class.guild.current_reputation_level
	$VBoxContainer/HBoxContainer2/ProgressBar.value = customer.hero_class.guild.current_reputation_xp
	$VBoxContainer/HBoxContainer2/ProgressBar.max_value = Enums.reputation_xp_per_level[customer.hero_class.guild.current_reputation_level]
	$VBoxContainer/HBoxContainer2/ProgressBar/CurrentRep.text = "%s/%s" % [
		customer.hero_class.guild.current_reputation_xp,
		Enums.reputation_xp_per_level[customer.hero_class.guild.current_reputation_level],
	]
