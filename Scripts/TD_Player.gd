extends KinematicBody
class_name Player
export(NodePath) var GunPosPath = ""
export(NodePath) var player;

var maxHp = 100
var hp = maxHp

var mouse_sensitivity = 1
var divide_mouse_sensitivity = 1
var velocity = Vector3.ZERO
var MAX_SPEED = 7.5
var ACCELERATION = 50.0
var level_camera = null
var gun_position: Position3D
onready var BULLET = preload("res://Scenes/Bullets/Bullet.tscn")
onready var WeaponMount = $WeaponMount
var weapons = []

const RAY_LENGTH = 100
var raycast_position = null

onready var rnd = RandomNumberGenerator.new()
onready var hit_sfx: AudioStreamPlayer3D = $HitSound
onready var power_ups = $PowerUps


func _ready():
	Global.player_node = get_node(player)

	rnd.randomize()
	gun_position = get_node(GunPosPath)
	weapons.append_array(WeaponMount.get_children())
	DebugOverlay.draw.add_vector(self, "velocity", 1, 4, Color(0, 1, 0, 0.5))
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
	
	move_dir.z = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	move_dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
#	print_debug(move_dir)
#	move_dir = move_dir.rotated(Vector3.UP, rotation.y)
	if move_dir != Vector3.ZERO:
		velocity = velocity.move_toward(move_dir * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector3.ZERO, ACCELERATION * delta)
	velocity = move_and_slide(velocity)

func check_fire() -> void:
	if (Input.is_action_pressed("shoot")):
#		print_debug(weapons)
		for weap in weapons:
#			print_debug(weap)
			if weap.has_method("fire"):
				weap.fire()


func take_damage(dmg: float) -> void:
	Global.emit_signal("shake", 0.1)
	hp -= dmg

	hit_sfx.play()
	print_debug("Player HP left: " + String(hp))

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
