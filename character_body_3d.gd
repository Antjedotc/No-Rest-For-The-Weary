extends CharacterBody3D

@export var camera: Camera3D
const SPEED = 5.0
const JUMP_VELOCITY = 4.5


func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var camera_basis := camera.global_transform.basis
	var camera_forward := (-camera_basis.z)
	camera_forward.y = 0.0
	camera_forward = camera_forward.normalized()
	
	var camera_right := camera_basis.x
	camera_right.y = 0.0
	camera_forward = camera_forward.normalized()
	
	var input_dir := Input.get_vector("game_left", "game_right", "game_up", "game_down")
	var direction := Vector3(camera_right * input_dir.x + camera_forward * -input_dir.y).normalized()

	var target_point = global_position + direction
	
	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		look_at(target_point, Vector3.UP)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
