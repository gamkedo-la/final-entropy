extends Node

signal shake(val)

var ortho_camera: Camera = null
var player_camera: Camera = null
var player_cam_anim: AnimationPlayer = null

var raycast_position = null
var player_node: Spatial = null



func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	

func set_camera(cam: Camera):
	ortho_camera = cam


func set_player_camera(cam: Camera, anim: AnimationPlayer, pivot: Position3D):
	player_camera = cam
	player_cam_anim = anim
	

func _unhandled_key_input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pause()

	var muted = AudioServer.is_bus_mute(0)
	if event.is_action_pressed("mute"):
		AudioServer.set_bus_mute(0, !muted)
		GUIOverlay.toggle_muted(!muted)


func toggle_pause():
	get_tree().paused = !get_tree().paused
	GUIOverlay.toggle_menu(get_tree().paused)
	OptionsMenu.enabled(get_tree().paused)


func transition_camera() -> void:
	player_camera.current = true
	
	player_cam_anim.play("LevelTransition")

func level_camera() -> void:
	ortho_camera.current = true
	player_cam_anim.stop()

func reparent(child: Node, new_parent: Node):
	if child:
		var old_parent = child.get_parent()
		if old_parent != new_parent:
			old_parent.remove_child(child)
			new_parent.add_child(child)
	else:
		print_debug("Global.gd: Attempt to reparent child node failed due to child being null.")
