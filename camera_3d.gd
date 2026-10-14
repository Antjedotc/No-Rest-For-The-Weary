extends Camera3D

@export var player: Node3D
var target_position: Vector3 = Vector3(0, 0, 0)

const CAMERA_OFFSET: Array[Vector3] = [Vector3(-2.5, 2, -2.5), 
		Vector3(0, 8, 5)]

var myCameraMode: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rootnode = get_tree().current_scene as Node3D
	if rootnode:
		myCameraMode = rootnode.get_meta("CameraMode", 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player:
		global_position = player.global_position + CAMERA_OFFSET[myCameraMode]
		target_position = player.global_position
		look_at(target_position, Vector3.UP)
		
