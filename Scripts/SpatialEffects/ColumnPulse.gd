extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var pulseTween = Tween.new()
onready var columnMeshMaterial: Material = $ColumnMesh.material

# Called when the node enters the scene tree for the first time.
func _ready():
#	if is_instance_valid(columnMeshMaterial):
#		call_deferred("add_child", pulseTween)
#		call_deferred("init_tween")
	pass

func init_tween() -> void:
	pulseTween.connect("tween_all_completed", self, "_pulseTween_complete")
	pulseTween.interpolate_property(columnMeshMaterial, "emission_energy", columnMeshMaterial.emission_energy, 2.0, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	pulseTween.start()
	pass # Replace with function body.

func _pulseTween_complete() -> void:
#	print_debug("pulseTween complete")
	if columnMeshMaterial.emission_energy >= 1.8:
		pulseTween.interpolate_property(columnMeshMaterial, "emission_energy", columnMeshMaterial.emission_energy, 0.7, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	else:
		pulseTween.interpolate_property(columnMeshMaterial, "emission_energy", columnMeshMaterial.emission_energy, 2.0, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	pulseTween.start()
	


func _on_Column01_area_entered(area):
	if area.is_in_group("bullet"):
		if area.bounces < 1:
			area.hit()
		else:
			area.velocity = area.velocity * -0.5
		area.bounces -= 1
	pass # Replace with function body.
