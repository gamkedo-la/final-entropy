extends KinematicBody

onready var noise = OpenSimplexNoise.new()
var noise_y = 0

export (NodePath) var ai_path
export (NodePath) var steering_path
export (NodePath) var body_path

var ai
var steering
var body

#temp movement logic
export(float) var MAX_SPEED = 10.0
export(float) var ACCELERATION = 10.0

export(float) var health = 1000.0
var velocity: Vector3 = Vector3.ZERO

func _ready():
	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2
	if is_instance_valid(ai_path):
		ai = get_node(ai_path)
	if is_instance_valid(steering_path):
		steering = get_node(steering)
	if is_instance_valid(body_path):
		body = get_node(body)
		
	pass # Replace with function body.

func _physics_process(delta) -> void:
	move_state(delta)

func move_state(delta) -> void:
	var move_dir: Vector3 = Vector3.ZERO
	noise_y += 1 
	move_dir.x = noise.get_noise_2d(noise.seed, noise_y)
	move_dir.z = noise.get_noise_2d(noise.seed*2, noise_y)

	if move_dir != Vector3.ZERO:
		velocity = velocity.move_toward(move_dir * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector3.ZERO, ACCELERATION * delta)
	velocity = move_and_slide(velocity)

func take_damage(dmg: float) -> void:
	health -= dmg
	if health <= 0:
		call_deferred("queue_free")
	pass

func _on_HitBox_area_entered(area):
	if area.is_in_group("bullet"):
		take_damage(area.damage)
		area.hit()
	pass # Replace with function body.
