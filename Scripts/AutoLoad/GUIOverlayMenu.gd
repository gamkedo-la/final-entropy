extends Panel

onready var Animation = $AnimationPlayer


func _on_GUIOverlayMenu_visibility_changed():
	if visible:
		Animation.play("Paused")
