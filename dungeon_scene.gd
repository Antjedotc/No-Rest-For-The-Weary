extends Node3D

@export var GridMapToEdit: GridMap
@export var PlayerObject: Pawn
var grid: PackedInt32Array = PackedInt32Array()
@export var width: int
@export var height: int

var NPCArray: Array[Walker] = []

const FastWFC = preload("addons/Godot_Fast_WFC/FastWFC.gd")
var rng = RandomNumberGenerator.new()

# WFC wrapper instance
var wfc: FastWFCWrapper

# File paths
var input_image_path = "res://addons/Godot_Fast_WFC/demo/overlapping/Rooms.png"
var image_output_path = "res://addons/Godot_Fast_WFC/demo/overlapping/Rooms_output.png"
var constraint_path = "res://addons/Godot_Fast_WFC/demo/overlapping/3x3_pattern.png"

# Generation parameters
var pattern_size = 3  # Larger values (e.g., 4) produce output closer to input
var periodic_input = true  # Rooms.png tiles seamlessly
var periodic_output = false  # Tileable outputs. Very handy. Doesnt always work
var ground = false  # No special ground pattern handling needed for this demo
var symmetry = 8  # Use all possible pattern rotations and reflections of detected patterns
var myseed = 12323  # Deterministic seed

var exitDoor: Vector3i = Vector3i(0,0,0) #IMPLEMENT ME

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("ready")
	make_floor()
	PlayerObject.grid_cell_occupied = Vector3i(width/2,0,height/2)
	start_player_turn()

#---GENERATION-----------------------------------------

#MAIN FLOOR GENERATION THING
func make_floor() -> void:
	initialize_grid()
	generate_layout_test()
	place_grid_in_world()
	spawn_enemies(3)

func generate_layout():
	for w in width:
		for h in height:
			grid_set_cell(w, h, 0)

#LETS WRITE SOME FUN ALGO RITHMGS
func generate_layout_test():
	print("trying...1")
	wfc = FastWFCWrapper.new()
	
	# Convert images to color arrays for WFC processing
	var color_array = FastWFC.png_to_color_array(input_image_path)
	var pattern_array = FastWFC.png_to_color_array(constraint_path)
	print("trying...2")

	# Initialize overlapping WFC with input parameters
	wfc.initialize_overlapping_from_array(
		color_array,
		width,
		height,
		pattern_size,
		periodic_input,
		periodic_output,
		ground,
		symmetry,
		myseed
	)

	# Apply pattern constraints across the top row
	# This forces the specified pattern to appear at regular intervals
	# Breaks periodic output on most seeds
	var constraint_spacing = 3
	for i in range(0, width, constraint_spacing):
		wfc.set_pattern_from_array(pattern_array, 0, i)
	
	# Generate the WFC result
	var result = wfc.generate()
	print("trying...3")

	for w in width:
		for h in height:
			grid_set_cell(w, h, result[w][h].r)
	
	if result.size() > 0:
		print("generation success")
	else:
		printerr("WFC generation failed - try adjusting parameters or seed")

#PLACES THE ARRAY VALUES AS GRIDMAP TILES
func place_grid_in_world():
	
	#places array values
	for y in range(height):
		for x in range(width):
			
			GridMapToEdit.set_cell_item(Vector3i(x,0,y), grid_get_cell(x, y))
	
	#generates border of tile 0
	for y in range(height+2):
		if y == 0:
			for x in range(width+2):
				GridMapToEdit.set_cell_item(Vector3i(x-1,0,y-1), 0)
		elif y == height+1:
			for x in range(width+2):
				GridMapToEdit.set_cell_item(Vector3i(x-1,0,y-1), 0)
		else:
			GridMapToEdit.set_cell_item(Vector3i(width, 0, y-1), 0)
			GridMapToEdit.set_cell_item(Vector3i(-1, 0, y-1), 0)

## places <num> enemies on random tiles in the grid
func spawn_enemies(num: int) -> void:
	var sucessful_spawns:= 0
	while sucessful_spawns < num:
		var candidate_cell = Vector3i(rng.randi() % width, 0, rng.randi() % height)
		if GridMapToEdit.is_cell_free(candidate_cell):
			register_NPC(GridMapToEdit.spawn_critter(candidate_cell))
			sucessful_spawns = sucessful_spawns + 1

func register_NPC(pawn: Pawn) -> void:
	NPCArray.append(pawn)
	pawn.died.connect(_on_pawn_died)

#---TURN SYSTEM-------------------------------------

enum State { PLAYER_TURN, NPC_TURN }
var current_state: State = State.PLAYER_TURN

func start_player_turn() -> void:
	current_state = State.PLAYER_TURN
	PlayerObject.take_turn()
	
func _on_player_pawn_action_completed() -> void:
	
	start_npc_turns()
	
func start_npc_turns() -> void:
	current_state = State.NPC_TURN
	for critter in NPCArray:
		critter.take_turn()
	start_player_turn()

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

#---SIGNAL HANDLERS-----------------------------------------

func _on_pawn_died(pawn: Pawn):
	NPCArray.erase(pawn)
