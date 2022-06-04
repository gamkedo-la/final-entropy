extends Position3D

onready var rnd = RandomNumberGenerator.new()
onready var BULLET = preload("res://Scenes/Bullets/Rocket.tscn")
onready var shot_sfx: AudioStreamPlayer3D = $ShotSFX
export var weapFireBaseMult: float = 0.5
export var base_rpm: float = 1
var since_fire: float = 0.0
var fire_wait: float = 0.0

func _ready():
	if not PlayerVars.is_connected("rounds_per_minute_bonus_changed", self, "_update_rpm"):
		var con_res = PlayerVars.connect("rounds_per_minute_bonus_changed", self, "_update_rpm")
		assert(con_res == OK)
	_update_rpm()
	pass # Replace with function body.

func _process(delta):
	since_fire += delta

func fire() -> void:
	if since_fire > fire_wait:
		shot_sfx.play()
		rnd.randomize()
		var bullet = BULLET.instance()
		add_child(bullet)
		bullet.collision_layer = 0b00000000000000000010
		bullet.collision_mask = 0b00000000000000000101
		bullet.set_as_toplevel(true)
		bullet.transform = global_transform
		bullet.velocity = -bullet.transform.basis.z * PlayerVars.shotSpeed
		since_fire = 0.0
		
func _update_rpm() -> void:
	fire_wait = 60/max(1,(base_rpm + PlayerVars.rounds_per_minute_bonus))
