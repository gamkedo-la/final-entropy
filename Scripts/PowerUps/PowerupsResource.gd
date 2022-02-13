tool
extends Resource
class_name PowerUps

export (Array, PackedScene) var powerup_scenes setget set_powerups


func set_powerups(value) -> void:
	powerup_scenes.resize(value.size())
	powerup_scenes = value

