class_name MyBoard
extends Match3Board

# hack to modify what needs to be modified
var selected_ability: Ability = null


static func middle_elements(array: Array):
	var array_size = 3
	var index = 1
	var to_return = []
	while array.size() >= array_size:
		to_return.append(array[index])
		index += 1
		array_size += 1
	return to_return


func select_ability(ability: Ability):
	selected_ability = ability


func deselect_ability():
	selected_ability = null


func on_selected_piece(piece: Match3Piece) -> void:
	if selected_ability and not is_locked:
		var done = selected_ability.execute_ability(self, piece)
		if done:
			deselect_ability()
	else:
		super.on_selected_piece(piece)


# function mostly kept same, marked 2 addition with comments
func consume_sequences(sequences: Array[Match3Sequence]) -> void:
	var sequences_result: Array[Match3SequenceConsumer.Match3SequenceConsumeResult] = sequence_consumer.sequences_to_combo_rules(sequences)

	if animator:
		if configuration.sequence_animation_is_serial():
			for sequence_result in sequences_result:
				for combo: Match3SequenceConsumer.Match3SequenceConsumeCombo in sequence_result.combos:
					await animator.run(Match3Animator.ConsumeSequenceAnimation, [combo.sequence])

		elif configuration.sequence_animation_is_parallel():
			await animator.run(Match3Animator.ConsumeSequencesAnimation, [sequences_result])

	for sequence_result in sequences_result:
		for combo: Match3SequenceConsumer.Match3SequenceConsumeCombo in sequence_result.combos:
			if combo.sequence.contains_special_piece():
				add_special_pieces_to_queue(combo.sequence.special_pieces())

			consumed_sequence.emit(combo.sequence.duplicate())
			# Addition 1 start
			var refining = false
			var refined_config
			if (combo.sequence.all_pieces_are_the_same() and combo.sequence.pieces().size() > 0
				and combo.sequence.pieces()[0].shape in Enums.base_shape_to_refined_configuration ):
				refining = true
				refined_config = Enums.base_shape_to_refined_configuration[combo.sequence.pieces()[0].shape]
			# Addition 1 end

			combo.sequence.consume_normal_cells()
			await get_tree().process_frame

			if combo.special_piece_to_spawn:
				var piece: Match3Piece = Match3Piece.from_configuration(combo.special_piece_to_spawn)
				draw_piece_on_cell(piece.spawn(self, combo.sequence), piece)
				piece.is_locked = true

			# Addition 2 start
			if refining:
				for cell in middle_elements(combo.sequence.cells):
					var piece = Match3Piece.from_configuration(refined_config)
					if cell.is_empty():
						draw_piece_on_cell(cell, piece)
					else:
						# can happen on cross shape match with overlapping middles
						# -x-
						# xxx
						# -X-
						var neighbor = find_empty_neighbor(cell)
						if neighbor:
							draw_piece_on_cell(neighbor, piece)
					piece.is_locked = true

			# Addition 2 end

	consumed_sequences.emit(sequences)

	await get_tree().process_frame

	if pending_special_pieces.is_empty():
		travel_to(BoardState.Fall if (BoardState.Consume or BoardState.SpecialConsume) else BoardState.Consume)
	else:
		if state_is_special_consume():
			consume_special_pieces(pending_special_pieces)
		else:
			travel_to(BoardState.SpecialConsume)


func swap_movement_is_valid(from_cell: Match3GridCell, to_cell: Match3GridCell) -> bool:
	if current_available_moves == 0:
		return false
	return super.swap_movement_is_valid(from_cell, to_cell)


func find_empty_neighbor(cell: Match3GridCell) -> Match3GridCell:
	for neighbor in cell.neighbours():
		if neighbor and neighbor.is_empty():
			return neighbor
	return null
