extends Camera


#shake variables
onready var noise = OpenSimplexNoise.new()
var noise_y = 0

export var decay = 0.8
export var max_offset = Vector2(1, 1)
export var max_roll = 0.1


var trauma = 0.0
var trauma_power = 2


onready var indicator = $Cylinder
var raycast_position
var ignore_bodies = []

# Called when the node enters the scene tree for the first time.
func _ready():
	if not get_parent() is LevelController && !get_parent().get_parent().debug_mode:
		current = false
		call_deferred("queue_free")
		return
	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2
	Global.set_camera(self)
	if not Global.is_connected("shake", self, "increase_trauma"):
		var con_res = Global.connect("shake", self, "increase_trauma")
		assert(con_res == OK)
	indicator.set_as_toplevel(true)
	pass # Replace with function body.

func _process(delta) -> void:

	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()
	if Input.is_action_just_pressed("camera_1"):
		projection = Camera.PROJECTION_ORTHOGONAL
	elif Input.is_action_just_pressed("camera_2"):
		projection = Camera.PROJECTION_PERSPECTIVE

func _physics_process(_delta):
	project()

func increase_trauma(val:float) -> void:
	trauma += val

func project() -> void:
	# Note: this assumes you are using a action for the mouse.
	# you might need to replace this with a different method to detect
	# whether the mouse has been clicked.
	
	var mouse_position = get_viewport().get_mouse_position()
	Global.mouse_position = project_ray_origin(mouse_position)
	Global.mouse_direction = project_ray_normal(mouse_position)
#	var raycast_from = project_ray_origin(mouse_position)
#	var raycast_to = raycast_from + project_ray_normal(mouse_position) * 1000
	# You might need a collision mask to avoid objects like the player...
#	var space_state = get_world().direct_space_state
#	for body in ignore_bodies:
#		if ! is_instance_valid(body):
#			ignore_bodies.erase(body)
#	var raycast_result = space_state.intersect_ray(raycast_from, raycast_to, ignore_bodies)
#	if (raycast_result):
#		print_debug(raycast_result)
		# store the location.
#		Global.raycast_position = raycast_result["position"]
#		indicator.translation = Global.raycast_position
#		var result_parent = raycast_result.collider.get_parent()
#		if raycast_result.collider is StaticBody or raycast_result.collider is GridMap:
#			Global.raycast_position = raycast_result["position"]
#			indicator.translation = Global.raycast_position
#		else:
#			ignore_bodies.append(raycast_result.collider)

func shake() -> void:
	var amount = pow(trauma, trauma_power)
	noise_y += 1 
	rotation.z = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	h_offset = max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
	v_offset = max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)
