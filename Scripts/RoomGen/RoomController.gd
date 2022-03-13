tool
extends Spatial



onready var camera_position = $CameraPos
onready var player_spawn = $PlayerSpawn
onready var stage = $Stage
onready var enemies = $Stage/Enemies
onready var room_portal = preload("res://Scenes/Rooms/RoomPortal.tscn")
export (String) var room_name = "A1" setget set_name
export (Array, NodePath) var room_portals 
export (Array, String) var connected_rooms
var room_clear = false

#Level Vars
var level_controller: LevelController = null

# Called when the node enters the scene tree for the first time.
func _ready():	
	if not Engine.editor_hint:
		call_deferred("remove_child", stage)
	pass # Replace with function body.

func initialize(_lc:LevelController) -> void:
	level_controller = _lc

func set_name(new_name) -> void:	
	if Engine.editor_hint:
		if room_name != new_name:
			room_name = new_name
			name = "Room" + room_name

func activate() -> void:
	call_deferred("add_child", stage)
	call_deferred("_connect_enemies")
	
func deactivate() -> void:
	call_deferred("remove_child", stage)

func _connect_enemies() -> void:
	var res_con
	for enemy in enemies.get_children():
		if not enemy.is_connected("dead", self, "_enemy_dead"):
			res_con = enemy.connect("dead", self, "_enemy_dead")
			assert(res_con == OK)

func _enemy_dead(enemy:Actor) -> void:
	enemies.remove_child(enemy)
	print_debug("Enemy Died")
	print_debug("Total Enemies Left:", enemies.get_child_count())
	if enemies.get_child_count() < 1:
		print_debug("Stage Clear")
		_stage_clear()
		
func _stage_clear() -> void:
	
	for i in room_portals.size():
		var new_portal = room_portal.instance()
		var portal_node = get_node_or_null(room_portals[i])
		portal_node.add_child(new_portal)
		new_portal.global_transform = portal_node.global_transform
