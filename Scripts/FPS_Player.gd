extends KinematicBody

var mouse_sensitivity = 1
var divide_mouse_sensitivity = 1
var velocity = Vector3.ZERO
var MAX_SPEED = 10.0
var ACCELERATION = 10.0

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.


func _physics_process(delta):
	move_state(delta)
		
	pass
	
func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensitivity / 18 / divide_mouse_sensitivity
	if Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func move_state(delta):
	var move_dir = Vector3.ZERO
	
	move_dir.z = Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
	move_dir.x = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
	print_debug(move_dir)
	move_dir = move_dir.rotated(Vector3.UP, rotation.y)
	if move_dir != Vector3.ZERO:
		velocity = velocity.move_toward(move_dir * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector3.ZERO, ACCELERATION * delta)
	velocity = move_and_slide(velocity)
