extends KinematicBody
class_name Player

const GRAVITY = 9.8

export(NodePath) var GunPosPath = ""
export(NodePath) var player;

onready var ground_ray: RayCast = $GroundRay

var maxHp = 100
var hp = maxHp

var mouse_sensitivity = 1
var divide_mouse_sensitivity = 1

var velocity = Vector3.ZERO
var MAX_SPEED = 7.5
var ACCELERATION = 50.0

export (float, 1.0, 10.0) var mass = 8.0
export (float, 0.1, 3.0, 0.1) var gravity_scl = 1.0
var gravity_speed = 0.0

var level_camera = null
var gun_position: Position3D
onready var BULLET = preload("res://Scenes/Bullets/Bullet.tscn")
onready var WeaponMount = $WeaponMount
var weapons = []

const RAY_LENGTH = 100
var raycast_position = null

# Dash Mechanic
var dash_now: bool = false
var invuln_time: float = 2.0
var dash_meter: float = 20.0
var dash_recharge_time: float = 3.0
var dash_recharge_elapse: float = 0.0

onready var rnd = RandomNumberGenerator.new()
onready var hit_sfx: AudioStreamPlayer3D = $HitSound
onready var power_ups = $PowerUps


func _ready():
	Global.player_node = get_node(player)
	ground_ray.enabled = true
	rnd.randomize()
	gun_position = get_node(GunPosPath)
	weapons.append_array(WeaponMount.get_children())
	DebugOverlay.draw.add_vector(self, "velocity", 1, 4, Color(0, 1, 0, 0.5))
	print_debug("Weapons: ", weapons)

func _physics_process(delta):
	recharge(delta)
	rotate_to_cursor()
	move_state(delta)
	check_fire()

func _input(event):
#	if event is InputEventMouseMotion:
#		rotation_degrees.y -= event.relative.x * mouse_sensitivity / 18 / divide_mouse_sensitivity
	if Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_just_pressed("dash"):
		dash_now = true
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
				Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)


func rotate_to_cursor() -> void:
	if Global.raycast_position:
		look_at(Vector3(Global.raycast_position.x, translation.y, Global.raycast_position.z), Vector3.UP)
	
func move_state(delta):
	gravity_speed -= GRAVITY * gravity_scl * mass * delta
	var move_dir = Vector3.ZERO
	# Not Dashing
	if !dash_now:
		move_dir.z = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		move_dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		if ground_ray.is_colliding():
			velocity.y = 0.0
		else:
			velocity.y = gravity_speed
		if move_dir != Vector3.ZERO:
			velocity = velocity.move_toward(move_dir * MAX_SPEED, ACCELERATION * delta)
		else:
			velocity = velocity.move_toward(Vector3.ZERO, ACCELERATION * delta)
	# Dashing
	if dash_now:
		move_dir = -transform.basis.z
		if ground_ray.is_colliding():
			velocity.y = 0.0
		else:
			velocity.y = gravity_speed
		velocity = velocity.move_toward(move_dir * MAX_SPEED*10, ACCELERATION)
		dash_now = false
		pass
	velocity = move_and_slide(velocity)

func check_fire() -> void:
	if (Input.is_action_pressed("shoot")):
#		print_debug(weapons)
		for weap in weapons:
#			print_debug(weap)
			if weap.has_method("fire"):
				weap.fire()

func recharge(delta: float) -> void:
	pass

func take_damage(dmg: float) -> void:
	Global.emit_signal("shake", 0.1)
	hp -= dmg

	hit_sfx.play()
	print_debug("Player HP left: " + String(hp))

func spawn_at_portal(portal:Spatial) -> void:
	if is_instance_valid(portal):
		global_transform = portal.global_transform

func _on_HitBox_area_entered(area):
#	print_debug("Area entered player", area)
	$TextureProgress2.value = int((float(hp) / maxHp) * 100)
	if area.is_in_group("bullet"):
		take_damage(area.damage)
		area.hit()


func _on_PickupRadius_area_entered(area):
	if area.is_in_group("pickup"):
		#TODO: Pickup and apply powerup
		var pickup = area.get_parent()
		if pickup.pick_active:
			print_debug("Picking up: ", pickup)
			pickup.pickup()
			Global.reparent(pickup, power_ups)
		
	pass # Replace with function body.
