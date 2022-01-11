extends Position3D

export(bool) var enemy = false
var guns = []
export (PackedScene) var bullet_path
var BULLET
onready var rnd = RandomNumberGenerator.new()
var since_fire: float = 0.0
export (float) var initial_velocity_modifier = 1.0
export var firerate: float  = 0.20
export var firetime: float = 5.0
export var cooldown: float = 5.0
var cool_time: float = 5.0
var firing: float = 0.0 
var can_fire: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	guns = get_children()
	BULLET = bullet_path
	cool_time = cooldown
	pass # Replace with function body.

func _physics_process(delta) -> void:
	if firing < firetime && can_fire:
		fire_guns(delta)
		firing += delta
		cool_time = cooldown
	else:
		can_fire = false
	
	if !can_fire:
		cool_time -= delta
		if cool_time <= 0.0:
			cool_time = 0.0
			firing = 0.0
			can_fire = true
#	rotation_degrees.y += 2.0
	rotate_y(0.05)

func fire_guns(delta) -> void:
	since_fire += delta
	var complete: float = clamp(firing / firetime,0.2, 1.0)
	if (since_fire > firerate * complete):
		rnd.randomize()
		for gun in guns:

			if gun is Position3D:
				var bullet = BULLET.instance()
				gun.add_child(bullet)
				if enemy:
					bullet.collision_layer = 0b00000000000000000100
					bullet.collision_mask = 0b00000000000000000011
				else:
					bullet.collision_layer = 0b00000000000000000010
					bullet.collision_mask = 0b00000000000000000101
				bullet.set_as_toplevel(true)
				bullet.transform = gun.global_transform
#				bullet.apply_central_impulse(-bullet.transform.basis.z * (0.25 * rnd.randf_range(0.75, 1.0)))
				bullet.velocity = -bullet.transform.basis.z * initial_velocity_modifier
		since_fire = 0.0
