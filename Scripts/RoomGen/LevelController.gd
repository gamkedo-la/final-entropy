extends Spatial
class_name LevelController

onready var room_node = $Rooms
onready var main_camera = $OrthoCamera
onready var player = $TopDown_Player

export (String) var first_room = "A1"
onready var start_timer = Timer.new()
var rooms = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for room in room_node.get_children():
		rooms.append(room)
	add_child(start_timer)
	start_timer.wait_time = 2.0
	start_timer.connect("timeout", self, "_start_level")
	start_timer.one_shot = true
	start_timer.start()


	
func _start_level() -> void:
	for i in rooms.size():
		if rooms[i].room_name == first_room:
			print_debug("FOUND ROOM", rooms[i].room_name)
			main_camera.global_transform = rooms[i].camera_position.global_transform
			player.global_transform = rooms[i].player_spawn.global_transform
			rooms[i].activate()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
