extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_body_entered(body: Node3D) -> void:
	print("penis mysterious")
	print(body.name)
	if body.is_in_group("player_group"):
		print("penis serious")
		if body.has_method("die"):
			body.die()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
