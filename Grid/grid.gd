#From Godot's "Role Playing Game (RPG) Demo"

class_name Grid
extends GridMap

enum CellType {
	ACTOR,
	OBSTACLE,
	OBJECT,
}

enum TileType {
	WALL,
	WALKABLE,
}

@export var dialogue_ui: Node
@export var gameboard: GameBoard
var meshlib_index_types = [TileType.WALL, TileType.WALKABLE, TileType.WALKABLE]

var ENEMY_PAWN = preload("res://enemy_pawn.tscn")

func _ready() -> void:
	for child in get_children():
		#assumes children are Pawns 
		gameboard.set_cell_pawn(local_to_map(child.position), child)

## returns a target vector as a GRID CELL (Vector3i.ZERO if request denied)
## for walkers, feed this output into move_to_cell()
func request_move(pawn: Pawn, direction: Vector2i) -> Vector3i:
	var cell_start := pawn.grid_cell_occupied
	
	var cell_target : Vector3i = cell_start + Vector3i(direction.x * roundf(cell_size.x), 0, direction.y * roundf(cell_size.z))
	#print("Moving from ", cell_start, " to ", cell_target)

	if is_cell_free(cell_target):
		return cell_target
	else:
		return Vector3i.ZERO
	
## checks if <cell> contains a pawn or wall
func is_cell_free(cell: Vector3i) -> bool:
	if gameboard.has_pawn(cell):
		return false
	elif get_cell_item(cell) == TileType.WALL:
		return false
	else:
		return true

## returns the Pawn at <cell>, or null if none.
func who_is_here(cell: Vector3i) -> Pawn:
	return gameboard.get_cell_pawn(cell)
	


## CALL THIS RIGHT BEFORE MOVING!! uses GRID TILE INDEXES, not global coordinates!!!
func confirm_move(pawn: Pawn, old_position: Vector3i, new_position: Vector3i) -> void:
	gameboard.remove_cell_pawn(old_position)
	gameboard.set_cell_pawn(new_position, pawn)

## spawns at enemy at <cell>
func spawn_critter(cell: Vector3i) -> NPCpawn:
	var newCritter = ENEMY_PAWN.instantiate() 
	add_child(newCritter)
	newCritter.grid_cell_occupied = cell
	enter_board(newCritter, cell)
	return newCritter

## Places a pawn at a given cell
func enter_board(pawn: Pawn, grid_cell_occupied: Vector3i):
	gameboard.set_cell_pawn(grid_cell_occupied, pawn)

func is_tile_out_of_bounds(cell: Vector3i) -> bool:
	#IMPLEMENT ME
	return true
