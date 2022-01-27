extends KinematicBody

export(NodePath) var GunPosPath = ""

var maxHp = 100
var hp = maxHp

var mouse_sensitivity = 1
var divide_mouse_sensitivity = 1
var velocity = Vector3.ZERO
var MAX_SPEED = 7.5
var ACCELERATION = 25.0
var level_camera = null
var gun_position: Position3D
onready var BULLET = preload("res://Scenes/Bullet.tscn")
onready var WeaponMount = $WeaponMount
var weapons = []

const RAY_LENGTH = 100
var raycast_position = null

onready var rnd = RandomNumberGenerator.new()
var fired: bool = false
export var firerate: float = 0.8
var since_fire: float = 0.0

func _ready():
	rnd.randomize()
	gun_position = get_node(GunPosPath)
	weapons.append_array(WeaponMount.get_children())
	print_debug("Weapons: ", weapons)

func _physics_process(delta):
	rotate_to_cursor()
	move_state(delta)
	check_fire()

func _input(event):
#	if event is InputEventMouseMotion:
#		rotation_degrees.y -= event.relative.x * mouse_sensitivity / 18 / divide_mouse_sensitivity
	if Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
				Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)


func rotate_to_cursor() -> void:
	if Global.raycast_position:
		look_at(Vector3(Global.raycast_position.x, translation.y, Global.raycast_position.z), Vector3.UP)
	
func move_state(delta):
	var move_dir = Vector3.ZERO
	
	move_dir.z = Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
	move_dir.x = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
#	print_debug(move_dir)
#	move_dir = move_dir.rotated(Vector3.UP, rotation.y)
	if move_dir != Vector3.ZERO:
		velocity = velocity.move_toward(move_dir * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector3.ZERO, ACCELERATION * delta)
	velocity = move_and_slide(velocity)

func check_fire() -> void:
	if (Input.is_action_pressed("shoot")):
		print_debug(weapons)
		for weap in weapons:
			print_debug(weap)
			if weap.has_method("fire"):
				weap.fire()
#		Global.emit_signal("shake", 0.035)
#		rnd.randomize()
#		var bullet = BULLET.instance()
#		add_child(bullet)
#		bullet.collision_layer = 0b00000000000000000010
#		bullet.collision_mask = 0b00000000000000000101
#		bullet.set_as_toplevel(true)
#		bullet.transform = gun_position.global_transform
##		bullet.direction = get_global_transform().basis.z
##		bullet.apply_central_impulse(-transform.basis.z * (0.25 * rnd.randf_range(0.75, 1.0)))
#		bullet.velocity = -bullet.transform.basis.z * 5
#		since_fire = 0.0
#	pass

func take_damage(dmg: float) -> void:
	Global.emit_signal("shake", 0.1)
	hp -= dmg
	print_debug("Player HP left: " + String(hp))

func _on_HitBox_area_entered(area):
#	print_debug("Area entered player", area)
	if area.is_in_group("bullet"):
		take_damage(area.damage)
		area.hit()
