extends Position3D

onready var rnd = RandomNumberGenerator.new() #rnd.randf_range(min,max)
export (Array, Resource) var shots
export(NodePath) var target = null

var index = 0
var timer = 0
var targetAngle = 0
var angleOffset = 0
var targetPosition : Position3D = null

func _ready():
	rnd.randomize()
	timer = shots[index].delay
	if target:
		targetPosition = get_node(target)

func _process(delta):
	if shots[index].angleRange < 360.0 and shots[index].angleRange >= 0.0:
		if targetPosition:
			var targetPos = Vector2(targetPosition.global_transform.origin.x, targetPosition.global_transform.origin.z)
			var pos = Vector2(global_transform.origin.x, global_transform.origin.z)
			targetAngle = targetPos.angle_to_point(pos)
		elif Global.player_node:
			var playerPos = Vector2(Global.player_node.global_transform.origin.x, Global.player_node.global_transform.origin.z)
			var pos = Vector2(global_transform.origin.x, global_transform.origin.z)
			targetAngle = playerPos.angle_to_point(pos)

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
			bullet.velocity.x = shots[index].bulletSpeed * cos(targetAngle + deg2rad((-shots[index].angleRange / 2) + angleOffset + ((i / float(shots[index].bullets)) * shots[index].angleRange)))
			bullet.velocity.z = shots[index].bulletSpeed * sin(targetAngle + deg2rad((-shots[index].angleRange / 2) + angleOffset + ((i / float(shots[index].bullets)) * shots[index].angleRange)))
		angleOffset += shots[index].angleOffset
		timer = shots[index].delay
		index = index + 1
		if index >= shots.size():
			index = 0
	else:
		timer -= delta
