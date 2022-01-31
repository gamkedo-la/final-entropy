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

class RayHits:
	var object
	var hits_array_name
	var radius
	var color
	var draws
	
	func _init(_object, _hits_array, _radius, _color):
		object = _object
		hits_array_name = _hits_array
		radius = _radius
		color = _color
		draws = 1
	
	func draw(node, camera: Camera):
		var unproj_hit
		var hits_array = object.get(hits_array_name)
		for hit in hits_array:
			unproj_hit = camera.unproject_position(hit)
#			node.draw_circle((hit - object.global_transform.origin), radius, color)
			node.draw_circle(unproj_hit, radius, color)



var vectors = []  # Array to hold all registered values.
var steer_rays = []
var ray_hits = []
var ray_hits_tracked = []

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
	for ray_hit in ray_hits:
		ray_hit.draw(self, camera)
		
func add_vector(object, property, scale, width, color):
	vectors.append(Vector.new(object, property, scale, width, color))

func add_rayarray(object, ray_array, scale, width, color):
	steer_rays.append(SteerRay.new(object, ray_array, scale, width, color))

func add_hitarray(object, hits_array, radius, color):
	if ray_hits.size() > 0:
		for hits in ray_hits:
			if hits.object == object:
				hits.hits_array = hits_array
				hits.radius = radius
				hits.color = color				
				return	
	ray_hits.append(RayHits.new(object, hits_array, radius, color))
