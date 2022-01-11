extends CSGTorus

export(Vector3) var spin_amount


func _ready():
	pass # Replace with function body.

func _process(delta) -> void:
	rotation += spin_amount * delta

