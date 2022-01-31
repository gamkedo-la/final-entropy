extends Position3D

export (PackedScene) var bullet_path
var BULLET
onready var rnd = RandomNumberGenerator.new()

var timer = 0
var delay = 0.2

func _ready():
	rnd.randomize()
	BULLET = bullet_path

func _process(delta):
	if timer <= 0:
		var bullet = BULLET.instance()
		add_child(bullet)
		bullet.set_as_toplevel(true)
		bullet.transform = global_transform
		bullet.collision_layer = 0b00000000000000000100
		bullet.collision_mask = 0b00000000000000000011
		bullet.velocity.x = rnd.randf_range(-2.0,2.0)
		bullet.velocity.z = rnd.randf_range(-2.0,2.0)
		timer = delay
	else:
		timer = timer - delta
