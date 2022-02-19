extends KinematicBody
class_name Actor

onready var noise = OpenSimplexNoise.new()
var noise_y = 0

onready var ai: AIController = $AI
onready var hit_box: Area = $HitBox

export (NodePath) var body_path
var body

#temp movement logic
export(float) var MAX_SPEED = 10.0
export(float) var ACCELERATION = 10.0

export (NodePath) var bar_path
var bar

export(float) var health = 1000.0
var maxHealth

var velocity: Vector3 = Vector3.ZERO
onready var powerup_drops = preload("res://Resources/PowerUps.tres")
onready var rng = RandomNumberGenerator.new()

func _ready():
	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2
	ai.initialize(self)
	if is_instance_valid(body_path):
		body = get_node(body_path)
	if not hit_box.is_connected("area_entered", self, "_on_HitBox_area_entered"):
		var con_res = hit_box.connect("area_entered", self, "_on_HitBox_area_entered")
		assert(con_res == OK)
	maxHealth = health
	bar = get_node(bar_path)


func _physics_process(delta) -> void:
#	move_state(delta)
	pass

func _process(delta) -> void: 
#	print_debug(powerup_drops.powerup_scenes)
	pass

	

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
	bar.scale.x = health / maxHealth
	var rand_scene = rng.randi_range(0, powerup_drops.powerup_scenes.size() - 1)
	print_debug(rand_scene)
	if health <= 0:
		drop_loot()
		call_deferred("queue_free")
	pass

func drop_loot() -> void:
	#TODO: Drop Chances etc..
	var rand_scene = rng.randi_range(0, powerup_drops.powerup_scenes.size() - 1)
	var new_powerup: RigidBody = powerup_drops.powerup_scenes[rand_scene].instance()
	new_powerup.transform.origin = transform.origin + (Vector3.UP) 
	get_tree().root.add_child(new_powerup)
	new_powerup.apply_central_impulse(Vector3.UP * 10)
	pass

func _on_HitBox_area_entered(area):
	if area.is_in_group("bullet"):
		take_damage(area.damage)
		area.hit()
	pass # Replace with function body.
