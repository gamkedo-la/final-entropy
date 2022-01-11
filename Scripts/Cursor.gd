extends Position3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(NodePath) var CameraPath = ""

var level_camera:Camera = null

var raycast_position

# Called when the node enters the scene tree for the first time.
func _ready():
	level_camera = get_node(CameraPath)
	pass # Replace with function body.

func _physics_process(delta):
	project()
	move_over_point()

func project() -> void:
	if !level_camera:
		level_camera = Global.ortho_camera

	# Note: this assumes you are using a action for the mouse.
	# you might need to replace this with a different method to detect
	# whether the mouse has been clicked.
	
	var mouse_position = get_tree().root.get_mouse_position()
	var raycast_from = level_camera.project_ray_origin(mouse_position)
	var raycast_to = level_camera.project_ray_normal(mouse_position)
	# You might need a collision mask to avoid objects like the player...
	var space_state = get_world().direct_space_state	
	var raycast_result = space_state.intersect_ray(raycast_from, raycast_to)
	if (raycast_result):
		# store the location.
		raycast_position = raycast_result["position"]

func move_over_point() -> void:
	if (raycast_position != null):
		global_transform
#		global_transform = raycast_position
	pass
	
