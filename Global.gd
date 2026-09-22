extends Node

var current_scene = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var root = get_tree().root
	#negative indices count from the back. this gets the last child of the root
	#the root's children are alwys 1. autoloaded nodes 2. current scene
	#so the current scene will be last always
	current_scene = root.get_child(-1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func goto_scene(path):
	#using Object.call_deferred means the function will only be called 
	#once all the code from the current scene is done running
	_deferred_goto_scene.call_deferred(path)
	
func _deferred_goto_scene(path):
		#remove current scene
	#current_scene.free()
		#load new scene
	#var s = ResourceLoader.load(path)
		#instance the new scene
	#current_scene = s.instantiate()
		#add it to the tree as the active scene
	#get_tree().root.add_child(current_scene)
	#get_tree().current_scene = current_scene #don't worry about it.
	get_tree().change_scene_to_file(path)
	
#generates a new dungeon floor
func make_new_floor(path: String = "res://DungeonScene.tscn"):
	_deferred_make_new_floor.call_deferred(path)

func _deferred_make_new_floor(path):
	get_tree().change_scene_to_file(path)
	
