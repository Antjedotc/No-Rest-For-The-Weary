#From Godot's "Role Playing Game (RPG) Demo"

## A pawn that can animate and walk around the grid.
class_name Walker
extends Pawn

signal action_completed

@export var combat_actor: PackedScene
@export var pose_anims: SpriteFrames

var lost: bool = false

#@onready var animation_playback: AnimationNodeStateMachinePlayback = $AnimationTree.get(&"parameters/playback")
@onready var walk_animation_time: float = 0.1 #$AnimationPlayer.get_animation(&"walk").length
#@onready var pose := $Pivot/Slime

const DO_TWEEN: bool = true
	
func take_turn():
	pass

## moves via global position
func move_to(target_position: Vector3) -> void:
	set_process(false) #turns off processing during animation?
	
	if(DO_TWEEN):
		
		grid.confirm_move(self, grid.local_to_map(position), grid.local_to_map(target_position))
		var move_direction := (target_position - position).normalized()
		#pose.play(&"idle")
		#animation_playback.start(&"walk")

		var tween := create_tween()
		tween.set_ease(Tween.EASE_IN)
		var end: Vector3 = position + move_direction * grid_size
		tween.tween_property(self, ^"position", end, walk_animation_time)

		await tween.finished
		#$Pivot.position = Vector3.ZERO
		#position = target_position
		#animation_playback.start(&"idle")
		#pose.play(&"idle")
		
	else:
		
		grid.confirm_move(self, grid.local_to_map(position), grid.local_to_map(target_position))
		position = target_position
	set_process(true)

## moves via grid cell index
func move_to_cell(target_cell: Vector3i) -> void:
	set_process(false) #turns off processing during animation?
	
	if(DO_TWEEN):
		#pose.play(&"idle")
		#animation_playback.start(&"walk")

		var tween := create_tween()
		tween.set_ease(Tween.EASE_IN)
		var end: Vector3 = grid.map_to_local(target_cell)
		tween.tween_property(self, ^"position", end, walk_animation_time)

		await tween.finished
		#$Pivot.position = Vector3.ZERO
		#position = target_position
		#animation_playback.start(&"idle")
		#pose.play(&"idle")
		
	else:
		position = grid.map_to_local(target_cell)
	
	grid.confirm_move(self, grid_cell_occupied, target_cell)
	grid_cell_occupied = target_cell
	set_process(true)

func bump() -> void:
	pass
	#set_process(false)
	#pose.play(&"bump")
	#animation_playback.start(&"bump")
	#await $AnimationTree.animation_finished
	#animation_playback.start(&"idle")
	#pose.play(&"idle")
	#set_process(true)
