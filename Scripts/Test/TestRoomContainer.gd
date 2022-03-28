extends Spatial


export (Resource) var room_container


# Called when the node enters the scene tree for the first time.
func _ready():
	for room in room_container.common_rooms:
		print_debug(room)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
