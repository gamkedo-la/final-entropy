extends CSGCombiner


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	_update_shape()
	var mesh = get_meshes()[1]
	ResourceSaver.save("res://test.mesh", mesh)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
