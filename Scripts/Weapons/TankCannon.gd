extends Position3D

signal knockback(val)

onready var rnd = RandomNumberGenerator.new()
onready var BULLET = preload("res://Scenes/Bullets/Bullet.tscn")
onready var shot_sfx: AudioStreamPlayer3D = $ShotSFX
export var shot_speed: float = 20
export var base_rpm: float = 300
export var shot_dmg: float = 1.0
export var knock_back: float = 0.2
var since_fire: float = 0.0
var fire_wait: float = 0.0

var actor
var steering
var ai

# Called when the node enters the scene tree for the first time.
func _ready():
	_update_rpm()

func _process(delta):
	since_fire += delta

func initialize(_actor, _steering, _ai) -> void:
	actor = _actor
	steering = _steering
	ai = _ai
	steering.register_weapon(self)
	
func fire() -> void:
	if since_fire > fire_wait:
#		shot_sfx.play()
		rnd.randomize()
		var bullet = BULLET.instance()
		add_child(bullet)
		bullet.collision_layer = 0b00000000000000000100
		bullet.collision_mask = 0b00000000000000000011
		bullet.set_as_toplevel(true)
		bullet.damage = shot_dmg
		bullet.transform = global_transform
		bullet.velocity = -bullet.transform.basis.z * shot_speed
		since_fire = 0.0
		emit_signal("knockback", knock_back)
func _update_rpm() -> void:
	fire_wait = 60/max(1,(base_rpm))
