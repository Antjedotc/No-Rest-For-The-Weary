#From Godot's "Role Playing Game (RPG) Demo"

class_name Grid
extends GridMap

enum CellType {
	ACTOR,
	OBSTACLE,
	OBJECT,
}

@export var dialogue_ui: Node
@export var gameboard: GameBoard

func _ready() -> void:
	for child in get_children():
		#assumes children are Pawns 
		gameboard.set_cell_pawn(local_to_map(child.position), child)

## returns a target vector as a GRID CELL (Vector3i.ZERO if request denied)
func request_move(pawn: Pawn, direction: Vector2i) -> Vector3i:
	var cell_start := pawn.grid_cell_occupied
	
	var cell_target : Vector3i = cell_start + Vector3i(direction.x * roundf(cell_size.x), 0, direction.y * roundf(cell_size.z))
	print("Moving from ", cell_start, " to ", cell_target)

	if gameboard.has_pawn(cell_target): #cell is occupied
		var target_pawn := gameboard.get_cell_pawn(cell_target)
		print("Cell %s contains %s" % [cell_target, target_pawn.name])

		if target_pawn.has_node(^"DialoguePlayer"):
			dialogue_ui.show_dialogue(pawn, target_pawn.get_node(^"DialoguePlayer"))
		return Vector3i.ZERO
			
	else: #cell is unoccupied
		return cell_target
	
## CALL THIS RIGHT BEFORE MOVING!! uses GRID TILE INDEXES, not global coordinates!!!
func confirm_move(pawn: Pawn, old_position: Vector3i, new_position: Vector3i) -> void:
	gameboard.remove_cell_pawn(old_position)
	gameboard.set_cell_pawn(new_position, pawn)

## Places a pawn at a given cell
func enter_board(pawn: Pawn, grid_cell_occupied: Vector3i):
	gameboard.set_cell_pawn(grid_cell_occupied, pawn)

func is_tile_out_of_bounds(cell: Vector3i) -> bool:
	#IMPLEMENT ME
	return true
