extends Node

signal shake(val)

var ortho_camera: Camera = null
var raycast_position = null

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

func set_camera(cam: Camera):
	ortho_camera = cam
	
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = !get_tree().paused
