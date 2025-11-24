extends VBoxContainer

@onready var board: MyBoard = $HBoxContainer/Matching/Node2D/Match3Board
@onready var board_container = $HBoxContainer/Matching
@onready var timer = $TurnCounter/TurnLabel
@onready var abilities = $Abilities/HBoxContainer


func _ready():
	board.consumed_sequence.connect(Materials.add_matched_materials)
	board.consumed_sequence.connect(add_energy_and_turn)
	board_container.resized.connect(_resize_board)
	board.movement_consumed.connect(update_timer)
	update_timer()
	for ability: Ability in BuildingProgress.get_abilities():
		ability.ability_deactivated.connect(board.deselect_ability)
		ability.ability_activated.connect(board.select_ability)
		abilities.add_child(ability)


func add_energy_and_turn(sequence: Match3Sequence):
	if sequence.pieces().size() >= 5:
		_add_extra_turn()
	var energy_to_add = sequence.pieces().size()
	get_tree().call_group("abilities", "add_energy", energy_to_add)


func update_timer():
	timer.text = "%s turns left" % board.current_available_moves


func _resize_board():
	var container_size_x = board_container.size[0]
	var container_size_y = board_container.size[1]
	var columns = board.configuration.grid_width
	var rows = board.configuration.grid_height
	# we want cells to be square
	var cell_size = floor(min(container_size_x / columns, container_size_y / rows))
	board.configuration.cell_size = Vector2i(cell_size, cell_size)
	var spare_space_horizontal = container_size_x - (cell_size * columns)
	var spare_space_vertical = container_size_y - (cell_size * rows)
	# board seems to start in middle of first cell
	board.set_position(Vector2((spare_space_horizontal + cell_size) / 2, (spare_space_vertical + cell_size) / 2))
	await board.draw_cells()
	await board.draw_pieces()


func _add_extra_turn():
	board.current_available_moves += 1
	update_timer()
