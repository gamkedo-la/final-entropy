extends Position3D

onready var rnd = RandomNumberGenerator.new()
onready var BULLET = preload("res://Scenes/Bullets/Bullet.tscn")
onready var shot_sfx: AudioStreamPlayer3D = $ShotSFX
export var weapFireBaseMult: float = 0.5
var since_fire: float = 0.0

func _ready():
	pass # Replace with function body.

func _process(delta):
	since_fire += delta

func fire() -> void:
	if since_fire > ((PlayerVars.fireRate * PlayerVars.fireRateMult) * weapFireBaseMult):
		shot_sfx.play()
		rnd.randomize()
		var bullet = BULLET.instance()
		add_child(bullet)
		bullet.collision_layer = 0b00000000000000000010
		bullet.collision_mask = 0b00000000000000000101
		bullet.set_as_toplevel(true)
		bullet.transform = global_transform
#		bullet.direction = get_global_transform().basis.z
#		bullet.apply_central_impulse(-transform.basis.z * (0.25 * rnd.randf_range(0.75, 1.0)))
		bullet.velocity = -bullet.transform.basis.z * PlayerVars.shotSpeed
		since_fire = 0.0
	pass
