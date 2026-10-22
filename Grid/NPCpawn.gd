## A pawn that can animate and walk around the grid.
class_name NPCpawn
extends Walker

var rng = RandomNumberGenerator.new()

func take_turn():
	print("IM DOING IT")
	random_wander()

func random_wander():
	
	var done = false
	
	while not done:
		var trymove = Vector2i(rng.randi() % 3 - 1, rng.randi() % 3 - 1)
		var target = grid.request_move(self, trymove)
		if target:
			done = true
			face_direction(trymove)
			move_to_cell(target)
		await get_tree().process_frame
	
