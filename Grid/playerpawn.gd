#From Godot's "Role Playing Game (RPG) Demo"

extends Walker

@export var Healthbar: ProgressBar

func _ready() -> void:
	MaxHealth = 100
	CurrentHealth = 100
	move_to_cell(grid_cell_occupied)

func take_turn():
	var done = false
	while not done:
		if Input.is_key_pressed(KEY_B):
			done = true
		elif Input.is_key_pressed(KEY_Z):
			cast_spell(facing_direction, 3, 20, 1)
		else:
			var input_direction: Vector2i = get_input_direction_ints()
			if not input_direction == Vector2i.ZERO:
				face_direction(input_direction)
				var target_cell: Vector3i = grid.request_move(self, input_direction)
				if target_cell:
					if not Input.is_key_pressed(KEY_SHIFT):
						done = true
						await move_to_cell(target_cell, true)
		await get_tree().process_frame
	
	action_completed.emit()

func get_input_direction() -> Vector2:
	return Input.get_vector(&"game_left", &"game_right", &"game_up", &"game_down")

func get_input_direction_ints() -> Vector2i:
	var input = Input.get_vector(&"game_left", &"game_right", &"game_up", &"game_down")
	return input.sign()

func update_UI() -> void:
	Healthbar.value = CurrentHealth
