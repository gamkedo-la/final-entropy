extends Node


# Player 
var baseHP: float = 100.0
var baseShields: float = 0.0

# Weapons
var fireRate: float = 1.0
var fireRateMult: float = 1.0
var shotDmg: float = 10.0
var shotDmgMult: float = 1.0
var bulletCount: int = 1

func _ready():
	pass # Replace with function body.

func pickup(power: PowerUP) -> void:
	baseHP += power.baseHP
	baseShields += power.baseShields
	fireRate += power.fireRate
	fireRateMult += power.fireRateMult
	shotDmg += power.shotDmg
	shotDmgMult += power.shotDmgMult
	bulletCount += power.bulletCount

func drop_pickup(power: PowerUP) -> void:
	baseHP -= power.baseHP
	baseShields -= power.baseShields
	fireRate -= power.fireRate
	fireRateMult -= power.fireRateMult
	shotDmg -= power.shotDmg
	shotDmgMult -= power.shotDmgMult
	bulletCount -= power.bulletCount
