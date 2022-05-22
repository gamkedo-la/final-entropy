extends Position3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (float) var rotation_speed = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	rotation_degrees += Vector3(rotation_speed, rotation_speed, rotation_speed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
