extends Spatial

var initialized: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.





# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	pass


func _on_Area_body_entered(body):
	if body is Player:
		print_debug("Player in portal")
#		body.spawn_at_portal(connected_portal)
		pass
	pass # Replace with function body.
