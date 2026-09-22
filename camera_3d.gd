extends Camera3D

@export var player: Node3D
const CAMERA_OFFSET_X = 3
const CAMERA_OFFSET_Z = 3
const CAMERA_OFFSET_Y = 5
var target_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target_position = Vector3(0, 0, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player:
		global_position = player.global_position + Vector3(CAMERA_OFFSET_X, CAMERA_OFFSET_Y, CAMERA_OFFSET_Z)
		target_position = player.global_position
		look_at(target_position, Vector3.UP)
		
