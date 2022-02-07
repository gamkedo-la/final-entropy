extends Position3D

onready var rnd = RandomNumberGenerator.new() #rnd.randf_range(min,max)
export (Array, Resource) var shots

var index = 0
var timer = 0
var angleOffset = 0

func _ready():
	rnd.randomize()
	timer = shots[index].delay

func _process(delta):
	if timer <= 0:
		for i in range(shots[index].bullets):
			var path = shots[index].bulletPaths[i % shots[index].bulletPaths.size()]
			if path == null:
				continue
			
			var bullet = path.instance()
			add_child(bullet)
			bullet.set_as_toplevel(true)
			bullet.transform = global_transform
			bullet.collision_layer = 0b00000000000000000100
			bullet.collision_mask = 0b00000000000000000011
			bullet.velocity.x = shots[index].bulletSpeed * cos(deg2rad(angleOffset + ((i / float(shots[index].bullets)) * 360.0)))
			bullet.velocity.z = shots[index].bulletSpeed * sin(deg2rad(angleOffset + ((i / float(shots[index].bullets)) * 360.0)))
		angleOffset += shots[index].angleOffset
		timer = shots[index].delay
		index = index + 1
		if index >= shots.size():
			index = 0
	else:
		timer -= delta
