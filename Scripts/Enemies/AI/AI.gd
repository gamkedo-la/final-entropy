extends Spatial
class_name AIController
signal state_changed(new_state)
signal near_player

onready var steering: Spatial = $Steering

var actor = null
var actor_velocity: Vector3 = Vector3.ZERO

var target: KinematicBody = null
var origin: Vector3 = Vector3.ZERO
var journey_distance: float = 0.0
var journey_percent: float = 0.0

var in_range: bool = false

enum State {
	PATROL,
	ENGAGE,
	IDLE,
	SLEEP,
	DEAD
}

var current_state: int = State.PATROL setget set_state

#State Timers
# Time to wait before firing on a newly engaged target, to avoid instant fire
onready var engage_timer = Timer.new()
export (float) var engage_speed = 2.0
# Time to wait to return to patrolling/stop chasing a just lost target
onready var patrol_timer = Timer.new()
export (float) var patrol_wait = 3.0
var patrol_target: Vector3 = Vector3.ZERO
export (float, 1.0, 100.0) var patrol_range = 100.0
var patrol_reached: bool = true
var num_patrol_points: int = 20
var current_patrol_point: int = 0
var patrol_points = []

# Time to wait to return to origin position after chasing a target to a new area
onready var origin_timer = Timer.new()
var origin_wait = 45

onready var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize()
	set_state(State.PATROL)

func _physics_process(_delta: float) -> void:
	if !actor:
		return
	
	match current_state:
		State.PATROL:
			_patrol()
		State.ENGAGE:
			_engage()
		State.SLEEP:
			_sleep()
		State.DEAD:
			_dead()
		_:
			printerr("Error: Found a state for enemy that should not exist", self)

func initialize(newActor):
	actor = newActor
	origin = actor.transform.origin
	_install_state_timers()
	print_debug("Getting to AI Initialize")
	steering.initialize(newActor, self)

func set_state(new_state: int) -> void:
	if new_state == current_state:
		return
	current_state = new_state
	emit_signal("state_changed", current_state)
	if current_state == State.DEAD && in_range == true:
		emit_signal("near_player", false)
		in_range = false

func get_current_target() -> Vector3:
	if target:
		return to_local(target.global_transform.origin)
	elif patrol_target:
		return to_local(patrol_target)
	else:
		return Vector3.ZERO

func _install_state_timers() -> void:
	add_child(engage_timer)
	engage_timer.wait_time = engage_speed
	add_child(patrol_timer)
	patrol_timer.wait_time = patrol_wait
	add_child(origin_timer)
	origin_timer.wait_time = origin_wait

func _patrol() -> void:
	if patrol_target.distance_to(actor.global_transform.origin) < 2:
		patrol_reached = true
	if !patrol_reached:
		journey_percent = clamp(actor.global_transform.origin.distance_to(patrol_target) / journey_distance, 0.2, 1.0)
	else:
		var random_x = rng.randf_range(-patrol_range, patrol_range)
		var random_z = rng.randf_range(-patrol_range, patrol_range)
		patrol_target = Vector3(random_x, actor.transform.origin.y, random_z) + origin


func _engage() -> void:
	pass

func _sleep() -> void:
	pass

func _dead() -> void:
	pass

