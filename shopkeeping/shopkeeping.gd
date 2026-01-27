extends VBoxContainer

var current_open_view: Node
var current_open_button: TextureButton


func on_button_press(button: TextureButton, view: Node):
	current_open_view.visible = false
	view.visible = true
	current_open_view = view
	current_open_button.button_pressed = false
	current_open_button.disabled = false
	button.disabled = true
	current_open_button = button


func setup_button(button: TextureButton, view: Node):
	current_open_view = $Shop
	current_open_button = $Tabs/ShopButton
	button.button_down.connect(func(): on_button_press(button, view))


func _ready() -> void:
	setup_button($Tabs/ShopButton, $Shop)
	setup_button($Tabs/CraftingButton, $Crafting)
	setup_button($Tabs/TownButton, $Town)
	setup_button($Tabs/HeroesButton, $Heroes)
	setup_button($Tabs/AdventureSellectButton, $AdventureSelect)
	setup_button($Tabs/GatheringSelectButton, $GatherSelect)
	$AndroidPadding.custom_minimum_size.y = Utils.get_screen_top_margin(self)
