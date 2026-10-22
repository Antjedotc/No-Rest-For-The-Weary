## LISTEN. ONLY grid.gd should call ANY of these functions.
class_name GameBoard
extends Node

# Maps a 3D grid position (Vector3i) to a reference of the Pawn or Object node
var pawns: Dictionary = {}

##pairs a grid tile index with a pawn
func set_cell_pawn(cell: Vector3i, pawn: Node) -> void:
	pawns[cell] = pawn

##clears associations with a grid tile
func remove_cell_pawn(cell: Vector3i) -> void:
	pawns.erase(cell)

##returns the pawn at a given grid tile (null if none)
func get_cell_pawn(cell: Vector3i) -> Node:
	return pawns.get(cell, null)

##returns true if the given grid cell is occupied
func has_pawn(cell: Vector3i) -> bool:
	return pawns.has(cell)
