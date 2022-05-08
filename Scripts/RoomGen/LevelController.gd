extends Spatial
class_name LevelController

signal level_loaded(all_rooms, room_loader)

onready var DebugOverlay = get_tree().root.get_node("DebugOverlay")

onready var room_node = $Rooms
onready var main_camera = $OrthoCamera
onready var player = $TopDown_Player

onready var lift_tween: Tween = Tween.new()
onready var trav_tween: Tween = Tween.new()
export (String) var first_room = "A1"
onready var start_timer = Timer.new()
var rooms = []

var drop_from_room
var drop_to_room

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("add_child", lift_tween)
	call_deferred("add_child", trav_tween)
	if not is_connected("level_loaded", GameLoader, "_on_LevelController_level_loaded"):
		connect("level_loaded", GameLoader, "_on_LevelController_level_loaded")
	if not is_connected("level_loaded", DebugOverlay, "_on_LevelController_level_loaded"):
		connect("level_loaded", DebugOverlay, "_on_LevelController_level_loaded")

	for room in room_node.get_children():
		rooms.append(room)
	add_child(start_timer)
	start_timer.wait_time = 0.1
	start_timer.connect("timeout", self, "_start_level")
	start_timer.one_shot = true
	start_timer.start()
	Global.level_camera()

	
func _start_level() -> void:
	if not lift_tween.is_connected("tween_all_completed", self, "_complete_lift"):
		var res_con = lift_tween.connect("tween_all_completed", self, "_complete_lift")
		assert(res_con == OK)	
	if not trav_tween.is_connected("tween_all_completed", self, "_complete_traversal"):
		var res_con = trav_tween.connect("tween_all_completed", self, "_complete_traversal")
		assert(res_con == OK)
		
	for i in rooms.size():
		rooms[i].initialize(self)
		if rooms[i].room_name == first_room:
			print_debug("FOUND ROOM", rooms[i].room_name)
			main_camera.global_transform = rooms[i].camera_position.global_transform
			main_camera.size = rooms[i].camera_size
			player.global_transform = rooms[i].player_spawn.global_transform
			rooms[i].activate()	
	emit_signal("level_loaded", rooms, funcref(self, "_traverse_to_room"))

func register_portal(new_portal:RoomPortal) -> void:
	if not new_portal.is_connected("traverse", self, "_traverse_to_room"):
		var res_con = new_portal.connect("traverse", self, "_traverse_to_room")
		assert(res_con == OK)

func _traverse_to_room(to_room, from_room = "", refresh_rooms = false) -> String:
	if refresh_rooms:
		rooms.clear()
		for room in room_node.get_children():
			rooms.append(room)
	
	var destination = player.global_transform.translated(Vector3.UP * 30)
	var cam_destination = main_camera.global_transform.translated(Vector3.UP * 50)
	Global.transition_camera()
	player.traversing = true
	drop_from_room = from_room
	drop_to_room = to_room
#	main_camera.projection = Camera.PROJECTION_PERSPECTIVE
	lift_tween.interpolate_property(player, "global_transform", player.global_transform, destination, 2.0, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	lift_tween.interpolate_property(main_camera, "global_transform", main_camera.global_transform, cam_destination, 1.0, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
#	lift_tween.interpolate_property(main_camera, "size", main_camera.size, cam_size, 2.0, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	lift_tween.start()

	return to_room

func _complete_lift() -> void:
	var destination
	var cam_destination
	var cam_size
	for i in rooms.size():
		if rooms[i].room_name == drop_from_room or drop_from_room.empty():
			rooms[i].deactivate()
		if rooms[i].room_name == drop_to_room:
#			main_camera.global_transform = rooms[i].camera_position.global_transform
			cam_destination = rooms[i].camera_position.global_transform
#			main_camera.size = rooms[i].camera_size
			cam_size = rooms[i].camera_size
#			player.global_transform = rooms[i].player_spawn.global_transform
			destination = rooms[i].player_spawn.global_transform
			rooms[i].return_room = drop_from_room
			rooms[i].activate()
	trav_tween.interpolate_property(player, "global_transform", player.global_transform, destination, 2.0, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	trav_tween.interpolate_property(main_camera, "global_transform", main_camera.global_transform, cam_destination, 2.0, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	trav_tween.interpolate_property(main_camera, "size", main_camera.size, cam_size, 2.0, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	trav_tween.start()
	emit_signal("level_loaded", rooms, funcref(self, "_traverse_to_room"))

func _complete_traversal() -> void:
#	main_camera.projection = Camera.PROJECTION_ORTHOGONAL
	Global.level_camera()
	player.traversing = false
	pass
