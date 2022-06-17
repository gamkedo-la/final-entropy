extends Node

# warning-ignore:unused_signal
signal rounds_per_minute_bonus_changed
# warning-ignore:unused_signal
signal hp_changed
# Player 
var baseHP: float = 100.0 setget _set_baseHP
var HP: float = baseHP
var baseShields: float = 0.0

# Weapons
var rounds_per_minute_bonus: float = 0.0 setget _set_rpm_bonus
var rounds_per_minute_bonus_max: float = 1800.0
var fireRate: float = 1.0
var fireRateMult: float = 1.0
var shotDmg: float = 10.0
var shotDmgMult: float = 1.0
var shotSpeed: float = 20.0
var bulletCount: int = 1

func _ready():
	pass # Replace with function body.

func emit_signal_if_value_changed(signal_name, value, change_amount) -> void:
	if change_amount != 0:
		emit_signal(signal_name, value, change_amount)

func emit_simple_signal_if_value_changed(signal_name, change_amount) -> void:
	if change_amount != 0:
		print_debug("Emitting ", signal_name)
		emit_signal(signal_name)

func _set_rpm_bonus(val) -> void:
	var previous_val = rounds_per_minute_bonus
	rounds_per_minute_bonus = clamp(val, 0.0, rounds_per_minute_bonus_max)
	emit_simple_signal_if_value_changed("rounds_per_minute_bonus_changed", rounds_per_minute_bonus - previous_val)

func _set_baseHP(val) -> void:
	print_debug("set_baseHP: ", val, " Current BaseHP: ", baseHP)
	var previous_val = baseHP
	baseHP = val
#	HP += val - previous_val
	HP = baseHP
	emit_simple_signal_if_value_changed("hp_changed", baseHP - previous_val)
