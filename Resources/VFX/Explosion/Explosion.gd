extends Spatial


export (Array,NodePath) var particle_collection

# Called when the node enters the scene tree for the first time.
func _ready():
	for particle in particle_collection:
		var part = get_node(particle)
		part.emitting = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
