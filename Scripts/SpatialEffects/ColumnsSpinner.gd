extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var spinTween: Tween = Tween.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("add_child", spinTween)
	call_deferred("init_tween")
	pass

func init_tween() -> void:
# warning-ignore:return_value_discarded
	spinTween.connect("tween_all_completed", self, "_spinTween_complete")
# warning-ignore:return_value_discarded
	spinTween.interpolate_property(self, "rotation_degrees:y", rotation_degrees.y, 359, 18.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
# warning-ignore:return_value_discarded
	spinTween.start()
	pass # Replace with function body.

func _spinTween_complete() -> void:
	if rotation_degrees.y >= 350:
# warning-ignore:return_value_discarded
		spinTween.interpolate_property(self, "rotation_degrees:y", rotation_degrees.y, 0, 18.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	else:
# warning-ignore:return_value_discarded
		spinTween.interpolate_property(self, "rotation_degrees:y", rotation_degrees.y, 359, 18.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
# warning-ignore:return_value_discarded
	spinTween.start()

