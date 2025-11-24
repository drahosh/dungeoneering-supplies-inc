extends Ability


func _ready():
	texture = load("res://res/abilities/ForestIcons_39_b.PNG")
	max_value = 200
	tooltip = "Collect all resources in a row"
	super._ready()


func execute_ability(board: Match3Board, piece: Match3Piece) -> bool:
	var row: Array = board.finder.cells_from_row(piece.cell.row)
	for cell: Match3GridCell in row:
		var shape = cell.piece.shape
		if shape in Enums.shape_to_material:
			Materials.change_material_amount(Enums.shape_to_material[shape], 1)
			cell.remove_piece(true)
		elif shape in Enums.base_shape_to_refined_configuration:
			cell.remove_piece(true)
			board.draw_piece_on_cell(
				cell,
				Match3Piece.from_configuration(Enums.base_shape_to_refined_configuration[shape]),
			)
		else:
			cell.remove_piece(true)
	board.travel_to(board.BoardState.Fall)
	return super.execute_ability(board, piece)
