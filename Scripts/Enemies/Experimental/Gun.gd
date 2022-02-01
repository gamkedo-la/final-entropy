extends Position3D

export (PackedScene) var bullet_path
var BULLET
onready var rnd = RandomNumberGenerator.new() #rnd.randf_range(min,max)
export var shotDelay = 0.5
export var reloadDelay = 2.0
export var reloadAfterShots = 4
export var bulletSpeed = 0.5
export var bulletsPerShot = 12
export var angleOffsetPerShot = 10

var shotTimer = 0
var reloadTimer = 0
var shots = 0
var angleOffset = 0

func _ready():
	rnd.randomize()
	BULLET = bullet_path
	reloadTimer = reloadDelay

func _process(delta):
	if reloadTimer <= 0:
		if shotTimer <= 0:
			for i in range(bulletsPerShot):
				var bullet = BULLET.instance()
				add_child(bullet)
				bullet.set_as_toplevel(true)
				bullet.transform = global_transform
				bullet.collision_layer = 0b00000000000000000100
				bullet.collision_mask = 0b00000000000000000011
				bullet.velocity.x = bulletSpeed * cos(deg2rad(angleOffset + ((i / float(bulletsPerShot)) * 360.0)))
				bullet.velocity.z = bulletSpeed * sin(deg2rad(angleOffset + ((i / float(bulletsPerShot)) * 360.0)))
			angleOffset += angleOffsetPerShot
			shotTimer = shotDelay
			shots += 1
			if shots >= reloadAfterShots:
				shots = 0
				reloadTimer = reloadDelay
		else:
			shotTimer -= delta
	else:
		reloadTimer -= delta
