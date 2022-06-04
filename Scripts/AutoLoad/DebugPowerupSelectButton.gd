extends Button

export (int) var index = 0
onready var powerup_drops = preload("res://Resources/PowerUps.tres")
var player

func _on_DebugPowerupSelectButton_mouse_exited():
	release_focus()


func _on_DebugPowerupSelectButton_pressed():
	var new_powerup: RigidBody = powerup_drops.powerup_scenes[index].instance()
	get_tree().root.add_child(new_powerup)
	new_powerup.global_transform.origin = player.global_transform.origin + (Vector3.UP * 3)

