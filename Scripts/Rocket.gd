extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (float) var damage = 10.0
export (int) var bounces = 0
export (float) var max_velocity = 8.0
var velocity = Vector3.ZERO

var time_alive: float = 0.0



func _physics_process(delta):
	time_alive += delta
	if time_alive >= 11.0:
		_remove()
	transform.origin += velocity * delta
	
	if velocity.length() > max_velocity:
		velocity = velocity/velocity.length()*max_velocity
	pass

func hit() -> void:
	_remove()


func _remove() -> void:
	call_deferred("queue_free")


func _on_Bullet_body_entered(body):
	if body is StaticBody:
		if bounces < 1:
			hit()
		else:
			velocity = velocity * -0.5
		bounces -= 1
