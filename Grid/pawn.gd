#From Godot's "Role Playing Game (RPG) Demo"

class_name Pawn
extends Node3D

enum CellType {
	ACTOR,
	OBSTACLE,
	OBJECT,
}
@onready var grid : Grid = get_parent()
var grid_size: float

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
