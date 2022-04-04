extends Panel

signal menu_toggled(is_visible)

var _is_visible = false

onready var Animation = $AnimationPlayer


func _ready():
	hide()


func toggle(is_visible):
	_is_visible = is_visible
	if is_visible and not Animation.is_playing():
		show()
		Animation.play("Paused")
	else:
		Animation.play_backwards("Paused")


func _on_AnimationPlayer_animation_finished(anim_name:String):
	if anim_name == "Paused": # Replace with function body.
		emit_signal("menu_toggled", _is_visible)
