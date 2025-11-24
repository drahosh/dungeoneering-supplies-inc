extends Ability


func _ready():
	texture = load("res://res/abilities/MiningIcons_08_b.PNG")
	max_value = 50
	tooltip = "destroy one piece (does not harvest it)"
	super._ready()


func execute_ability(board: Match3Board, piece: Match3Piece) -> bool:
	piece.cell.remove_piece(true)
	board.travel_to(board.BoardState.Fall)
	return super.execute_ability(board, piece)
