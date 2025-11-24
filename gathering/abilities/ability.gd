class_name Ability
extends VBoxContainer

signal ability_activated(ability: Ability) # emitted when ability is pressed and awaits coordinatees
signal ability_deactivated # emitted only when ability is deactivated by clicking on it again

var texture # to be set in implementation
var max_value # ditto
var tooltip # ditto, also TODO implement

@onready var bar = $AspectRatioContainer/TextureProgressBar
@onready var label = $Label
@onready var button = $AspectRatioContainer/Button


func _ready():
	#implementations are expected to call super._ready() after setting
	bar.texture_under = texture
	bar.texture_progress = texture
	bar.max_value = max_value
	update_energy(0)
	button.toggled.connect(toggle_button)
	add_to_group("abilities")


func toggle_button(toggled: bool):
	if toggled:
		activate_ability()
	else:
		ability_deactivated.emit()
		deactivate_ability()


func update_energy(value):
	bar.value = value
	label.text = "%s/%s" % [bar.value, bar.max_value]
	if bar.value >= bar.max_value:
		label.add_theme_color_override("font_color", Color.GREEN)
		button.disabled = false
	else:
		label.remove_theme_color_override("font_color")
		button.disabled = true
		button.button_pressed = false


func add_energy(value):
	update_energy(bar.value + value)


func activate_ability():
	# when buttin is clicked/pressed, await pressing a piece to activate ability
	ability_activated.emit(self)
	button.self_modulate.a = 256


func deactivate_ability():
	# called by parend on group when another ability is activated to make sure this one is not active
	button.button_pressed = false
	button.self_modulate.a = 0


func execute_ability(_board: Match3Board, _piece: Match3Piece) -> bool:
	# For implementation in each ability, end by calling this function in super
	# returns true if executed, false if not ( for example selected piece not suitable)
	update_energy(0)
	deactivate_ability()
	return true # executed
