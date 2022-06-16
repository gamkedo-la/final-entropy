extends KinematicBody
class_name Actor

signal dead

onready var noise = OpenSimplexNoise.new()
var noise_y = 0

onready var ai: AIController = $AI
onready var hit_box: Area = $HitBox

var body

# Boss?
export(bool) var is_a_boss = false

#temp movement logic
export(float) var MAX_SPEED = 10.0
export(float) var ACCELERATION = 10.0

export (NodePath) var bar_path
var bar

export(float) var health = 1000.0
var maxHealth

var velocity: Vector3 = Vector3.ZERO
onready var powerup_drops = preload("res://Resources/PowerUps.tres")
onready var explosion = preload("res://Resources/VFX/Explosion/Explosion.tscn")
var explo = null
onready var rng = RandomNumberGenerator.new()
export (float) var aggro_radius = 3.0
onready var aggro_sphere: CollisionShape = $AggroBox/AggroSphere
onready var die_sfx = $die
onready var die_stream = preload("res://SFX/explosiontry.wav")
onready var bossdie_stream = preload("res://Music/FinalEntropyBossDeathSound.mp3")
var boss_cntdwn: float = 0.0

func _ready():
	if is_a_boss:
		die_sfx.stream = bossdie_stream
	else:
		die_sfx.stream = die_stream
	if not die_sfx.is_connected("finished", self, "die"):
		var con_res = die_sfx.connect("finished", self, "die")
		assert(con_res == OK)
	
	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2
	ai.initialize(self)
	if not hit_box.is_connected("area_entered", self, "_on_HitBox_area_entered"):
		var con_res = hit_box.connect("area_entered", self, "_on_HitBox_area_entered")
		assert(con_res == OK)
	maxHealth = health
	bar = get_node(bar_path)
	aggro_sphere.shape.radius = aggro_radius

func _physics_process(delta) -> void:
#	move_state(delta)
	pass

func _process(delta) -> void: 
	if is_a_boss and die_sfx.playing:
		boss_cntdwn += delta
		if boss_cntdwn > .25:		
			rng.randomize()
			var new_explo = explosion.instance()
			get_tree().root.add_child(new_explo)
			new_explo.global_transform.origin = global_transform.origin + Vector3(
				rng.randf_range(-2.0, 2.0),
				0.0, 
				rng.randf_range(-3.0, 3.0)
				)
			boss_cntdwn = 0.0
#	print_debug(powerup_drops.powerup_scenes)
	pass

func grow_aggro() -> void:
	aggro_sphere.shape.radius = aggro_radius * 5

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

func drop_loot() -> void:
	#TODO: Drop Chances etc..
	rng.randomize()
	explo = explosion.instance()
	get_tree().root.add_child(explo)
	explo.global_transform.origin = global_transform.origin
	var new_powerup: RigidBody = powerup_drops.powerup_scenes[rng.randi() % powerup_drops.powerup_scenes.size()].instance()
	get_tree().root.add_child(new_powerup)
	new_powerup.global_transform.origin = global_transform.origin + (Vector3.UP)	
	new_powerup.apply_central_impulse(Vector3.UP * 10)
	ai.set_state(AIController.State.DEAD)
	hit_box.queue_free()
	visible = false
	die_sfx.play(0)
#	call_deferred("die")
	
func die() -> void:	
	if is_a_boss:
		Music.boss_inrange = false		
	get_parent().call_deferred("remove_child", self)
	call_deferred("emit_signal", "dead", self)
	call_deferred("queue_free")
	pass

func _on_HitBox_area_entered(area):
	if area.is_in_group("bullet"):
		if ai.current_state != ai.State.ENGAGE:
			grow_aggro()
		take_damage(area.damage)
		area.hit()
	pass # Replace with function body.
