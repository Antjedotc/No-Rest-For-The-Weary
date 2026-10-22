#From Godot's "Role Playing Game (RPG) Demo"

## A pawn that can animate and walk around the grid.
class_name Walker
extends Pawn

signal action_completed

@export var combat_actor: PackedScene
@export var pose_anims: SpriteFrames

@export var yOffset: float = 0
var facing_direction: Vector2i = Vector2i(-1, 0)

var lost: bool = false

#@onready var animation_playback: AnimationNodeStateMachinePlayback = $AnimationTree.get(&"parameters/playback")
@onready var walk_animation_time: float = 0.1 #$AnimationPlayer.get_animation(&"walk").length
#@onready var pose := $Pivot/Slime
	
func take_turn():
	pass

## moves via grid cell index
func move_to_cell(target_cell: Vector3i, do_tween: bool = true) -> void:
	set_process(false) #turns off processing during animation?
	
	if(do_tween):
		#pose.play(&"idle")
		#animation_playback.start(&"walk")

		var tween := create_tween()
		tween.set_ease(Tween.EASE_IN)
		var end: Vector3 = grid.map_to_local(target_cell) + Vector3(0,yOffset,0)
		tween.tween_property(self, ^"position", end, walk_animation_time)

		await tween.finished
		#$Pivot.position = Vector3.ZERO
		#position = target_position
		#animation_playback.start(&"idle")
		#pose.play(&"idle")
		
	else:
		position = grid.map_to_local(target_cell)  + Vector3(0,yOffset,0)
	
	grid.confirm_move(self, grid_cell_occupied, target_cell)
	grid_cell_occupied = target_cell
	set_process(true)
	
func face_direction(direction: Vector2i):
	facing_direction = direction
	look_at(position + Vector3(direction.x, 0, direction.y))
	
func update_UI() -> void:
	pass

## casts a Spell with the following parameters:
##
## length (int): number of tiles ahead of the caster affected by the spell
##		if length is zero, the spell does nothing. 
## damage (int): raw damage applied to each hit target
## targets (int): number of objects/enemies hit before spell ends
## Unimplemented: damage type
func cast_spell(direction: Vector2i, length: int, damage: int, targets: int):
	var hits = 0
	for i in range(length):
		var target_cell = grid_cell_occupied + Vector3i(direction.x, 0, direction.y) 
		var victim = grid.who_is_here(target_cell)
		if victim && hits < targets:
			print("HIT")
			victim.apply_damage(damage)
			hits = hits + 1
