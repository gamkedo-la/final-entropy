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
	start_timer.wait_time = 0.1
	start_timer.connect("timeout", self, "_start_level")
	start_timer.one_shot = true
	start_timer.start()


	
func _start_level() -> void:
	for i in rooms.size():
		rooms[i].initialize(self)
		if rooms[i].room_name == first_room:
			print_debug("FOUND ROOM", rooms[i].room_name)
			main_camera.global_transform = rooms[i].camera_position.global_transform
			player.global_transform = rooms[i].player_spawn.global_transform
			rooms[i].activate()

func register_portal(new_portal:RoomPortal) -> void:
	if not new_portal.is_connected("traverse", self, "_traverse_to_room"):
		var res_con = new_portal.connect("traverse", self, "_traverse_to_room")
		assert(res_con == OK)

func _traverse_to_room(to_room, from_room) -> void:
	for i in rooms.size():
		if rooms[i].room_name == from_room:
			rooms[i].deactivate()
		if rooms[i].room_name == to_room:
			main_camera.global_transform = rooms[i].camera_position.global_transform
			player.global_transform = rooms[i].player_spawn.global_transform
			rooms[i].return_room = from_room
			rooms[i].activate()
			
			
	pass

