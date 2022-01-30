extends Control

class Vector:
	var object  # The node to follow
	var property  # The property to draw
	var scale  # Scale factor
	var width  # Line width
	var color  # Draw color

	func _init(_object, _property, _scale, _width, _color):
		object = _object
		property = _property
		scale = _scale
		width = _width
		color = _color

	func draw(node, camera: Camera):
		var start = camera.unproject_position(object.global_transform.origin)
		var end = camera.unproject_position(object.global_transform.origin + object.get(property) * scale)
		node.draw_line(start, end, color, width)
#		node.draw_triangle(end, start.direction_to(end), width*2, color)

class SteerRay:
	var object
	var ray_array
	var scale
	var width
	var color
	
	func _init(_object, _ray_array, _scale, _width, _color):
		object = _object
		ray_array = _ray_array
		scale = _scale
		width = _width
		color = _color
	
	func draw(node, camera: Camera):
		var start
		var end
		for ray in ray_array:
			if ray:
				start = camera.unproject_position(object.global_transform.origin)
				end = camera.unproject_position(object.global_transform.origin + (ray * scale))
				node.draw_line(start, end, color, width)
			



var vectors = []  # Array to hold all registered values.
var steer_rays = []

func _process(delta):
	if not visible:
		return
	update()

func _draw():
	var camera = get_viewport().get_camera()
	for vector in vectors:
		vector.draw(self, camera)
	for steer_ray in steer_rays:
		steer_ray.draw(self, camera)
		
func add_vector(object, property, scale, width, color):
	vectors.append(Vector.new(object, property, scale, width, color))

func add_rayarray(object, ray_array, scale, width, color):
	steer_rays.append(SteerRay.new(object, ray_array, scale, width, color))
