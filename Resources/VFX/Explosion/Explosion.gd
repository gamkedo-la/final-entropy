extends Spatial


export (Array,NodePath) var particle_collection
var time := 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	for particle in particle_collection:
		var part = get_node(particle)
		part.emitting = true
	pass # Replace with function body.

func _process(delta):
	time += delta
	if time > 5.0:
		call_deferred("queue_free")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
