extends Node

signal shake(val)

var ortho_camera: Camera = null
var raycast_position = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_camera(cam: Camera):
	ortho_camera = cam
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
