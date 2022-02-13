extends RigidBody
class_name PowerUP

export (String) var powerUpName = ""
export (int) var indexNum = 0
#bonuses
export (float) var baseHP = 0.0
export (float) var baseShields = 0.0

# Weapons
export (float) var fireRate = 0.0
export (float) var fireRateMult = 0.0
export (float) var shotDmg: float = 0.0
export (float) var shotDmgMult: float = 0.0
export (float) var bulletCount: int = 0

onready var pickup_area: Area = $Area

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func pickup() -> void:
	pickup_area.monitorable = false
	visible = false

func drop() -> void:
	visible = true
	pickup_area.monitorable = true
