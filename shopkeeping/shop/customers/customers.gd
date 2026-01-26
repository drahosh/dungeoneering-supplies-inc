extends Control

func _ready() -> void:
	for customer in Guilds.active_customers:
		$ScrollContainer/VBoxContainer.add_child(CustomerView.get_new(customer))
