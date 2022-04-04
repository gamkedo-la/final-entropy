extends KinematicBody
class_name Player

signal powered_up(pickup)

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
var invuln_time: float = 0.2
var invuln_elapse: float = 0.0
var dash_max: float = 20.0
var dash_amount: float = dash_max setget set_dash
var dash_cost: float = 10.0
var dash_recharge_time: float = .1
var dash_recharge_elapse: float = 0.0
var dash_recharge_amount: float = 0.2
var invulnerable: bool = false
onready var dash_meter = $DashMeter

var traversing = false

onready var rnd = RandomNumberGenerator.new()
onready var hit_sfx: AudioStreamPlayer3D = $HitSound
onready var power_ups = $PowerUps


func _ready():
	if not is_connected("powered_up", GameLoader, "_on_TD_Player_powered_up"):
		connect("powered_up", GameLoader, "_on_TD_Player_powered_up")

	Global.player_node = get_node(player)
	ground_ray.enabled = true
	rnd.randomize()
	gun_position = get_node(GunPosPath)
	weapons.append_array(WeaponMount.get_children())
	DebugOverlay.draw.add_vector(self, "velocity", 1, 4, Color(0, 1, 0, 0.5))
	dash_meter.value = dash_amount
	print_debug("Weapons: ", weapons)
	add_to_group("Save")

func _physics_process(delta):
	if !traversing:
		recharge(delta)
		rotate_to_cursor()
		move_state(delta)
		check_fire()

func _input(event):
#	if event is InputEventMouseMotion:
#		rotation_degrees.y -= event.relative.x * mouse_sensitivity / 18 / divide_mouse_sensitivity
	if Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_just_pressed("dash") && dash_amount >= dash_cost:
		dash_now = true
		dash_amount -= dash_cost
		invuln_elapse = 0.0
		invulnerable = true
		
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

func set_dash(val):	
	print_debug("Getting to set_dash")
	dash_amount = clamp(val, 0.0, dash_max)
	dash_meter.value = dash_amount
		
func recharge(delta: float) -> void:
	if invulnerable:
		invuln_elapse += delta
		if invuln_elapse > invuln_time:
			invulnerable = false
			velocity = Vector3.ZERO
		
	if dash_amount < dash_max:
		dash_recharge_elapse += delta
		if dash_recharge_elapse >= dash_recharge_time:
			dash_recharge_elapse = 0.0
			dash_amount = clamp(dash_amount + dash_recharge_amount, 0.0, dash_max)		
	
	dash_meter.value = dash_amount
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
	if invulnerable:
		return
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
			print_debug("Player HP left: " + String(hp))
			emit_signal("powered_up", pickup)
		
	pass # Replace with function body.
