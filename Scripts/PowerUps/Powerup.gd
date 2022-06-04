extends RigidBody
class_name PowerUP

export (String) var powerUpName = ""
export (int) var indexNum = 0

# Weapon Addon?
export (bool) var isWeaponPowerUp = false
export (PackedScene) var weapon

#bonuses
export (float) var baseHP = 0.0
export (float) var baseShields = 0.0

# Weapons
export (float) var rounds_per_minute_bonus = 0.0
export (float) var shotDmg: float = 0.0
export (float) var shotDmgMult: float = 0.0
export (float) var shotSpeed: float = 0.0
export (float) var bulletCount: int = 0

onready var pickup_area: Area = $Area

var pick_active = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func pickup() -> void:
	sleeping = true
	pickup_area.monitorable = false
	visible = false
	pick_active = false
	if !isWeaponPowerUp:
		PlayerVars.baseHP += baseHP
		PlayerVars.baseShields += baseShields
		PlayerVars.rounds_per_minute_bonus += rounds_per_minute_bonus
		PlayerVars.shotDmg += shotDmg
		PlayerVars.shotDmgMult += shotDmgMult
		PlayerVars.shotSpeed += shotSpeed
		PlayerVars.bulletCount += bulletCount

func drop() -> void:
	visible = true
	pickup_area.monitorable = true
	sleeping = false
	pick_active = true
	if !isWeaponPowerUp:
		PlayerVars.baseHP -= baseHP
		PlayerVars.baseShields -= baseShields
		PlayerVars.rounds_per_minute_bonus -= rounds_per_minute_bonus
		PlayerVars.shotDmg -= shotDmg
		PlayerVars.shotDmgMult -= shotDmgMult
		PlayerVars.shotSpeed -= shotSpeed
		PlayerVars.bulletCount -= bulletCount

