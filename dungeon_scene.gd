extends Node3D

var grid: PackedInt32Array = PackedInt32Array()
var width: int = 50
var height: int = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	make_floor()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#GRID HELPERS
func initialize_grid() -> void:
	grid.clear()
	grid.resize(width * height)
	grid.fill(0)
	
func get_cell(x: int, y: int) -> int:
	return grid[y * width + x]
func set_cell(x: int, y: int, value: int) -> void:
	grid[y * width + x] = value
	
#GENERATES THE FLOOR
func make_floor() -> void:
	print("hooooly shit")
	initialize_grid()
	
func place_grid_in_world():
	pass
