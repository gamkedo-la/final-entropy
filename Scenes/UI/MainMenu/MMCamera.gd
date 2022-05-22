extends Camera


onready var wob_tween: Tween = $WobTween
onready var zoom_tween: Tween = $ZoomTween
var initial_rotation = Vector3.ZERO
var initial_zoom = Vector3.ZERO
onready var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	initial_rotation = rotation_degrees
	initial_zoom = translation
	var new_rotation = Vector3(rng.randf_range(-2.0,2.0),rng.randf_range(-2.0,2.0),rng.randf_range(-2.0,2.0)) + initial_rotation
	var new_trans = Vector3(0,rng.randf_range(-5,30),0) + initial_zoom
	wob_tween.interpolate_property(
		self, "rotation_degrees", rotation_degrees, new_rotation, 
		0.5,Tween.TRANS_ELASTIC,Tween.EASE_IN_OUT
		)
	zoom_tween.interpolate_property(
		self, "translation", translation, new_trans,
		3.0,Tween.TRANS_EXPO,Tween.EASE_OUT
		)
	wob_tween.start()
	zoom_tween.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_WobTween_tween_all_completed():
	var new_rotation = Vector3(rng.randf_range(-2.0,2.0),rng.randf_range(-2.0,2.0),rng.randf_range(-2.0,2.0)) + initial_rotation
	wob_tween.interpolate_property(
		self, "rotation_degrees", rotation_degrees, new_rotation,
		0.5,Tween.TRANS_ELASTIC,Tween.EASE_IN_OUT)
	wob_tween.start()


func _on_ZoomTween_tween_all_completed():
	var new_trans = Vector3(0,rng.randf_range(-5,30),0) + initial_zoom
	zoom_tween.interpolate_property(
		self, "translation", translation, new_trans,
		3.0,Tween.TRANS_EXPO,Tween.EASE_OUT
		)
	zoom_tween.start()
	pass # Replace with function body.
