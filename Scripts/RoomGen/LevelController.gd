extends Spatial


onready var room_node = $Rooms
onready var main_camera = $OrthoCamera
onready var player = $TopDown_Player

var rooms = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for room in room_node.get_children():
		rooms.append(room)
	pass # Replace with function body.
	main_camera.global_transform = rooms[0].camera_position.global_transform
	player.global_transform = rooms[0].player_spawn.global_transform

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
