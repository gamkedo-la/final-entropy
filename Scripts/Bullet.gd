extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var mesh = $CSGSphere
onready var particles = $Particles
onready var rnd = RandomNumberGenerator.new()
onready var meshInst: MeshInstance = MeshInstance.new()
onready var material: SpatialMaterial = SpatialMaterial.new()
onready var bLight: OmniLight = $OmniLight
export (Array, Color) var trail_color = [Color(1.0, 1.0, 1.0, 1.0)]
export (bool) var is_rainbow 
export (float) var damage = 10.0
export (int) var bounces = 0
export (float) var max_velocity = 10.0
var velocity = Vector3.ZERO
var tColor: Color

onready var timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rnd.randomize()
	call_deferred("add_child", timer)
	timer.wait_time = 5.0
	timer.connect("timeout", self, "_remove")
#	var material:SpatialMaterial = particles.draw_pass_1.surface_get_material(0)
	

	if is_rainbow:
		tColor = Color(rnd.randf_range(0.0,1.0),rnd.randf_range(0.0,1.0),rnd.randf_range(0.0,1.0),1.0)
	else:
		randomize()
		tColor = trail_color[rand_range(0, trail_color.size())]
	material.albedo_color = tColor
	material.emission = tColor
	bLight.light_color = tColor
	material.emission_enabled = true
	material.emission_energy = 4.0
	particles.draw_pass_1 = particles.draw_pass_1.duplicate(true) 
	particles.draw_pass_1.surface_set_material(0, material)
	pass # Replace with function body.


func _physics_process(delta):
	transform.origin += velocity * delta
	if velocity < max_velocity * Vector3.ONE:
		velocity = velocity * 1.02
	pass

func hit() -> void:

	mesh.visible = false
	particles.emitting = false
#	if bLight:
#		bLight.call_deferred("queue_free")
	
	timer.start()


func _remove() -> void:
	call_deferred("queue_free")


func _on_Bullet_body_entered(body):
	if body is StaticBody:
		if bounces < 1:
			hit()
		else:
			velocity = velocity * -0.5
		bounces -= 1
