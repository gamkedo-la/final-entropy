extends Node

signal shake(val)

var ortho_camera: Camera = null
var raycast_position = null
var player_node: Spatial = null

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

func set_camera(cam: Camera):
	ortho_camera = cam
	
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = !get_tree().paused
	
		
func _unhandled_key_input(event):
	var muted = AudioServer.is_bus_mute(0)
	if event.is_action_pressed("mute"):
		AudioServer.set_bus_mute(0, !muted)
		GUIOverlay.toggle_muted(!muted)


func reparent(child: Node, new_parent: Node):
	if child:
		var old_parent = child.get_parent()
		if old_parent != new_parent:
			old_parent.remove_child(child)
			new_parent.add_child(child)
	else:
		print_debug("Global.gd: Attempt to reparent child node failed due to child being null.")
