#From Godot's "Role Playing Game (RPG) Demo"

class_name Pawn
extends Node3D

enum CellType {
	ACTOR,
	OBSTACLE,
	OBJECT,
}
signal died(pawn: Pawn)
@onready var grid : Grid = get_parent()
var grid_size: float
var MaxHealth: int = 10
var CurrentHealth: int = 10

@export var type := CellType.ACTOR

var active: bool = true: set = set_active
## current location of pawn in the grid
@export var grid_cell_occupied: Vector3i = Vector3i(0,0,0)

func _ready() -> void:
	grid.enter_board(self, grid_cell_occupied)
	grid_size = grid.cell_size.x

func set_active(value: bool) -> void:
	active = value
	set_process(value)
	set_process_input(value)
	
func take_turn() -> void:
	pass
	
## subtracts damage from CurrentHealth.
## negative values heal.
## TO IMPLEMENT: damage types, DEATH
func apply_damage(damage: int) -> void:
	CurrentHealth = CurrentHealth - damage
	if not CurrentHealth > 0:
		die()

func die():
	if is_queued_for_deletion():
		return
	set_process(false)
	died.emit(self)
	print("fuck i'm DEAD!!!!!!!!!!!!")
	queue_free()
