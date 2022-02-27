extends Spatial


onready var camera_position = $CameraPos
onready var player_spawn = $PlayerSpawn
export (Array, NodePath) var room_portals 
var room_clear = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
