tool
extends Spatial
class_name RoomController

onready var camera_position: Position3D = $CameraPos
export (float) var camera_size = 16.0
onready var player_spawn: Position3D = $PlayerSpawn
onready var return_portal: Position3D = $Stage/ReturnPortal
onready var stage = $Stage
onready var enemies = $Stage/Enemies
onready var room_portal = preload("res://Scenes/Rooms/RoomPortal.tscn")
export (String) var room_name = "" setget set_name
export (Array, NodePath) var room_portals 
export (Array, String) var connected_rooms
var return_room: String = ""
var room_clear = false
var is_activated = false

export (bool) var debug_mode = false

#Level Vars
var level_controller: LevelController = null

# Called when the node enters the scene tree for the first time.
func _ready():	
	if not Engine.editor_hint && !debug_mode:		
		_clean_test()
		deactivate()
	name = room_name

func _clean_test() -> void:
	var test_world_env = get_node_or_null("Stage/WorldEnvironment")
	if test_world_env:			
		test_world_env.call_deferred("queue_free")
	for i in room_portals.size():
		var port_node = get_node_or_null(room_portals[i])
		if return_portal.get_child_count() > 0:
			for child in return_portal.get_children():
				return_portal.remove_child(child)
		if port_node:
			if port_node.get_child_count() > 0:
				for portal in port_node.get_children():
					portal.call_deferred("queue_free")

func initialize(_lc:LevelController) -> void:
	level_controller = _lc

func set_name(new_name) -> void:
	if room_name != new_name:
		room_name = new_name
	if Engine.editor_hint:
			name = "Room" + room_name

func activate() -> void:
	call_deferred("add_child", stage)
	call_deferred("_connect_enemies")
	is_activated = true
	
func deactivate() -> void:
	call_deferred("remove_child", stage)
	is_activated = false

func _connect_enemies() -> void:
	var res_con
	for enemy in enemies.get_children():
		if not enemy.is_connected("dead", self, "_enemy_dead"):
			res_con = enemy.connect("dead", self, "_enemy_dead")
			assert(res_con == OK)

func _enemy_dead(enemy:Actor) -> void:
	print_debug("Enemy Died")
	print_debug("Total Enemies Left:", enemies.get_child_count())
	if enemies.get_child_count() < 1:
		print_debug("Stage Clear")
		_stage_clear()
		
func _stage_clear() -> void:
	if return_room != "":
		var new_portal = room_portal.instance()
		return_portal.add_child(new_portal)
		new_portal.global_transform = return_portal.global_transform
		new_portal.current_room = room_name
		new_portal.connected_room = return_room
		level_controller.register_portal(new_portal)
		
	for i in min(room_portals.size(), connected_rooms.size()):
		if connected_rooms[i] != "":
			var new_portal = room_portal.instance()
			var portal_node = get_node_or_null(room_portals[i])
			portal_node.add_child(new_portal)
			new_portal.global_transform = portal_node.global_transform
			new_portal.current_room = room_name
			new_portal.connected_room = connected_rooms[i]
			level_controller.register_portal(new_portal)
	
