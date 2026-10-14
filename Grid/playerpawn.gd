#From Godot's "Role Playing Game (RPG) Demo"

extends Walker

func _process(_delta: float) -> void:
	pass

func take_turn():
	print("It's your turn! ")
	var done = false
	while not done:
		
		var input_direction: Vector2i = get_input_direction_ints()

		if not input_direction == Vector2i.ZERO:
			var target_cell: Vector3i = grid.request_move(self, input_direction)
			if target_cell:
				done = true
				move_to_cell(target_cell)
			elif active:
				bump()
		await get_tree().process_frame
	
	print("Done your turn!")
	action_completed.emit()

func get_input_direction() -> Vector2:
	return Input.get_vector(&"game_left", &"game_right", &"game_up", &"game_down")

func get_input_direction_ints() -> Vector2i:
	var input = Input.get_vector(&"game_left", &"game_right", &"game_up", &"game_down")
	return input.sign()
