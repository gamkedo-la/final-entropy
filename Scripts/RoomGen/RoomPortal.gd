extends Spatial

export (NodePath) var connected_portal_path
var connected_portal: Spatial

var initialized: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _init() -> void:
	connected_portal = get_node_or_null(connected_portal_path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !initialized:
		_init()
	pass


func _on_Area_body_entered(body):
	if body is Player:
		print_debug("Player in portal")
		body.spawn_at_portal(connected_portal)
		pass
	pass # Replace with function body.
