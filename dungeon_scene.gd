extends Node3D

@export var GridMapToEdit: GridMap
@export var PlayerObject: Node3D
var grid: PackedInt32Array = PackedInt32Array()
@export var width: int = 10
@export var height: int = 10
var playerStartsHere: Vector3 = Vector3(0,0,0)
var exitDoor: Vector3i = Vector3i(0,0,0) #IMPLEMENT ME

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	make_floor()
	PlayerObject.global_position = playerStartsHere

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#---GENERATION-----------------------------------------

#MAIN FLOOR GENERATION THING
func make_floor() -> void:
	initialize_grid()
	generate_layout()
	place_grid_in_world()
	playerStartsHere = Vector3(1, 2, 1)

#PLACES THE ARRAY VALUES AS GRIDMAP TILES
func place_grid_in_world():
	for y in range(height):
		for x in range(width):
			GridMapToEdit.set_cell_item(Vector3i(x,0,y), grid_get_cell(x, y))

#LETS WRITE SOME FUN ALGO RITHMGS
func generate_layout():
	var critter: Vector2i = Vector2i(width/2, height/2)
	for i in range(100):
		grid_set_cell(critter.x, critter.y, 1)
		var dir = randi() % 4
		var tomove = Vector2i(0,0)
		if(dir == 0): tomove = Vector2i(1,0)
		elif(dir == 1): tomove = Vector2i(0, -1)
		elif(dir == 2): tomove = Vector2i(-1, 0)
		else: tomove = Vector2i(0, 1)
		critter = critter + tomove
	#for y in range(height):
	#	for x in range(width):
	#		grid_set_cell(x, y, randi() % 2)

#---HELPERS-----------------------------------------

#GRID HELPERS
func initialize_grid() -> void:
	grid.clear()
	grid.resize(width * height)
	grid.fill(0)

func grid_get_cell(x: int, y: int) -> int:
	return grid[y * width + x]
func grid_set_cell(x: int, y: int, value: int) -> void:
	grid[y * width + x] = value
